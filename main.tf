##############
# Data sources
##############
data "aws_caller_identity" "current" {
}

data "aws_elb_service_account" "main" {
}

##############
# Elastic IP
##############
resource "aws_eip" "this" {
  count     = (var.internal == false && var.allocate_eip) ? length(var.subnet_ids) : 0
  vpc       = true
}

##############
# Loadbalancer
##############
resource "aws_lb" "this" {
  load_balancer_type               = "network"
  name                             = var.name
  internal                         = var.internal

  subnets                          = var.allocate_eip == false ? var.subnet_ids : null
  enable_cross_zone_load_balancing = var.cross_zone_load_balancing_enabled
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled

  dynamic "subnet_mapping" {
    for_each    = (var.internal == false && var.allocate_eip) ? var.subnet_ids : []
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.this[subnet_mapping.key].allocation_id
    }
  }

  access_logs {
    bucket  = var.enable_access_logs_s3 ? aws_s3_bucket.lb_logs[0].bucket : ""
    enabled = var.enable_access_logs_s3 ? true : false
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

# Target group with only one target
resource "aws_lb_target_group" "this" {
  count                 = var.target_group_target_several_targets == false ? length(var.listener_maps_list) : 0
  name                  = format("%s-%s", var.name, count.index)
  vpc_id                = var.vpc_id
  port                  = var.listener_maps_list[count.index].target_group_port
  protocol              = var.listener_maps_list[count.index].target_group_protocol
  target_type           = var.target_group_target_type
  deregistration_delay  = var.deregistration_delay

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )

  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "lb_to_instance" {
  count             = var.target_group_target_several_targets == false ? length(var.listener_maps_list) : 0
  target_group_arn  = aws_lb_target_group.this[count.index].arn
  target_id         = var.listener_maps_list[count.index].target_ids
  port              = var.listener_maps_list[count.index].target_group_port
}

resource "aws_lb_listener" "this" {
  count             = var.target_group_target_several_targets == false ? length(var.listener_maps_list) : 0
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_maps_list[count.index].listener_port
  protocol          = var.listener_maps_list[count.index].listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[count.index].arn
  }
}

# Target group with several targets
module "target_group_several_targets" {
  count     = var.target_group_target_several_targets ? length(var.listener_maps_list_several_targets) : 0
  source    = "./modules/target_group_several_targets"

  deregistration_delay          = var.deregistration_delay
  listener_map_several_targets  = var.listener_maps_list_several_targets[count.index]
  load_balancer_arn             = aws_lb.this.arn
  name                          = format("%s-%s", var.name, count.index)
  tags                          = var.tags
  target_group_target_type      = var.target_group_target_type
  vpc_id                        = var.vpc_id
}

################
# S3 Access Logs
################
resource "aws_s3_bucket" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = var.access_logs_s3_bucket_name != null ? var.access_logs_s3_bucket_name : var.name

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true

  depends_on = [aws_s3_bucket.lb_logs]
}

resource "aws_s3_bucket_acl" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id
  
  acl   = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id

  rule {
    id      = "log"

    transition {
      days          = var.access_logs_s3_transition_days
      storage_class = var.access_logs_s3_transition_storage_class
    }

    expiration {
      days = var.access_logs_s3_expiration_days
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

# sources:
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions

resource "aws_s3_bucket_policy" "lb_logs" {
  count  = var.enable_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs[0].bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs[0].bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs[0].bucket}"
    }
  ]
}
POLICY

  depends_on = [aws_s3_bucket.lb_logs]
}

###########################
# Athena für S3 Access Logs
###########################
resource "aws_s3_bucket" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = format("%s-athena-results", var.name)

  tags = merge(
    {
      Name = format("%s-athena-results", var.name)
    },
    var.tags,
  )
}

resource "aws_s3_bucket_acl" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_logs[0].id
  
  acl   = "private"
}

resource "aws_s3_bucket_public_access_block" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.athena_results_lb_logs[0].id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true

  depends_on = [aws_s3_bucket.athena_results_lb_logs]
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.athena_results_lb_logs[0].id

  rule {
    id      = "results"

    expiration {
      days = var.athena_access_logs_s3_expiration_days
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.athena_results_lb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_athena_database" "lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  name   = var.athena_access_logs_s3_db_name
  bucket = aws_s3_bucket.athena_results_lb_logs[0].id
}