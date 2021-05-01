##############
# Data sources
##############
data "aws_caller_identity" "current" {
}

data "aws_elb_service_account" "main" {
}

##############
# Loadbalancer
##############
resource "aws_lb" "this" {
  load_balancer_type               = "network"
  name                             = var.name
  internal                         = var.internal

  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = var.cross_zone_load_balancing_enabled
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    enabled = true
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "this" {
  count                 = length(var.listener_maps_list)
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
  count             = length(var.listener_maps_list)
  target_group_arn  = aws_lb_target_group.this[count.index].arn
  target_id         = var.listener_maps_list[count.index].target_ids
  port              = var.listener_maps_list[count.index].target_group_port
}

resource "aws_lb_listener" "this" {
  count             = length(var.listener_maps_list)
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_maps_list[count.index].listener_port
  protocol          = var.listener_maps_list[count.index].listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[count.index].arn
  }
}

################
# S3 Access Logs
################
resource "aws_s3_bucket" "lb_logs" {
  bucket = var.name
  acl    = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = var.access_logs_s3_transition_days
      storage_class = var.access_logs_s3_transition_storage_class
    }

    expiration {
      days = var.access_logs_s3_expiration_days
    }
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true

  depends_on = [aws_s3_bucket.lb_logs]
}

# sources:
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

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
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}"
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
  acl    = "private"

  lifecycle_rule {
    id      = "results"
    enabled = true

    tags = {
      "rule"      = "results"
      "autoclean" = "true"
    }

    expiration {
      days = var.athena_access_logs_s3_expiration_days
    }
  }

  tags = merge(
    {
      Name = format("%s-athena-results", var.name)
    },
    var.tags,
  )
}

resource "aws_s3_bucket_public_access_block" "athena_results_lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  bucket = aws_s3_bucket.athena_results_lb_logs[count.index].id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true

  depends_on = [aws_s3_bucket.athena_results_lb_logs]
}

resource "aws_athena_workgroup" "lb_logs" {
  count = var.enable_athena_access_logs_s3 ? 1 : 0
  name  = var.name

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results_lb_logs[count.index].bucket}"
    }
  }
}

resource "aws_athena_database" "lb_logs" {
  count  = var.enable_athena_access_logs_s3 ? 1 : 0
  name   = var.athena_access_logs_s3_db_name
  bucket = aws_s3_bucket.lb_logs.id
}