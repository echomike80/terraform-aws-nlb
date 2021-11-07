# AWS network load balancer Terraform module

Terraform module which creates a network load balancer with multiple listeners and target groups on AWS.

ATTENTION: This module creates target groups with only one (!) target by default. Please set switch 'target_group_target_several_targets' to true, to enable multiple target ids.

## Terraform versions

Terraform 0.12 and newer. 

## Usage

### Target group(s) with only one target id

```hcl
module "nlb" {
  source                                = "/path/to/module/terraform-aws-nlb"
  name                                  = var.name
  region                                = var.region
  vpc_cidr                              = var.vpc_cidr
  vpc_id                                = var.vpc_id
  subnet_ids                            = var.subnet_ids
  internal                              = var.internal
  target_ids                            = var.target_ids
  ip_address_type                       = var.ip_address_type

  target_group_target_several_targets   = false

  listener_maps_list                    =  [
    {
      listener_port             = var.listener_port_1                       # "8080", i.e.
      listener_protocol         = var.listener_protocol_1                   # "TCP", i.e.
      target_group_port         = var.target_group_port_1                   # "8080", i.e.
      target_group_protocol     = var.target_group_protocol_1               # "TCP", i.e.
      target_ids                = var.instance_id_1
    },
    {
      listener_port             = var.listener_port_2                       # "8088", i.e.
      listener_protocol         = var.listener_protocol_2                   # "TCP", i.e.
      target_group_port         = var.target_group_port_2                   # "8088", i.e.
      target_group_protocol     = var.target_group_protocol_2               # "TCP", i.e.
      target_ids                = var.instance_id_2
    },
    {
      listener_port             = var.listener_port_3                       # "9090", i.e.
      listener_protocol         = var.listener_protocol_3                   # "TCP", i.e.
      target_group_port         = var.target_group_port_3                   # "9090", i.e.
      target_group_protocol     = var.target_group_protocol_3               # "TCP", i.e.
      target_ids                = var.instance_id_3
    },
    ...
    ...
    ...
  ]

  enable_access_logs_s3                 = var.enable_access_logs_s3

  enable_athena_access_logs_s3          = var.enable_athena_access_logs_s3
  athena_access_logs_s3_db_name         = var.athena_access_logs_s3_db_name

  tags = {
    Environment = var.environment,
    Tier        = var.web_tier
  }
}
```

### Target group(s) with only one target id
```hcl
module "nlb_webproxy" {
  source                                = "/path/to/module/terraform-aws-nlb"
  name                                  = var.name
  region                                = var.region
  vpc_cidr                              = var.vpc_cidr
  vpc_id                                = var.vpc_id
  subnet_ids                            = var.subnet_ids
  internal                              = var.internal
  target_ids                            = var.target_ids
  ip_address_type                       = var.ip_address_type

  target_group_target_several_targets   = true

  listener_maps_list_several_targets    = [
    {
      listener_port             = var.listener_port_1                       # "8080", i.e.
      listener_protocol         = var.listener_protocol_1                   # "TCP", i.e.
      target_group_port         = var.target_group_port_1                   # "8080", i.e.
      target_group_protocol     = var.target_group_protocol_1               # "TCP", i.e.
      target_ids                = [var.instance_id_1, var.instance_id_2]
    },
    {
      listener_port             = var.listener_port_2                       # "8088", i.e.
      listener_protocol         = var.listener_protocol_2                   # "TCP", i.e.
      target_group_port         = var.target_group_port_2                   # "8088", i.e.
      target_group_protocol     = var.target_group_protocol_2               # "TCP", i.e.
      target_ids                = [var.instance_id_1, var.instance_id_2]
    }
  ]

  enable_access_logs_s3                 = var.enable_access_logs_s3

  enable_athena_access_logs_s3          = var.enable_athena_access_logs_s3
  athena_access_logs_s3_db_name         = var.athena_access_logs_s3_db_name

  tags = {
    Environment = var.environment,
    Tier        = var.web_tier
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.65 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_target_group_several_targets"></a> [target\_group\_several\_targets](#module\_target\_group\_several\_targets) | ./modules/target_group_several_targets | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_athena_database.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.lb_to_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |   
| [aws_s3_bucket.athena_results_lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.athena_results_lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.lb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |    
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_s3_bucket_name"></a> [access\_logs\_s3\_bucket\_name](#input\_access\_logs\_s3\_bucket\_name) | Name of the S3 bucket for access logs of Load Balancer | `string` | `null` | no |
| <a name="input_access_logs_s3_expiration_days"></a> [access\_logs\_s3\_expiration\_days](#input\_access\_logs\_s3\_expiration\_days) | Amount of days for expiration of S3 access logs of Load Balancer | `number` | `90` | no |
| <a name="input_access_logs_s3_transition_days"></a> [access\_logs\_s3\_transition\_days](#input\_access\_logs\_s3\_transition\_days) | Amount of days for S3 storage class to transition of access logs of Load Balancer | `number` | `30` | no |
| <a name="input_access_logs_s3_transition_storage_class"></a> [access\_logs\_s3\_transition\_storage\_class](#input\_access\_logs\_s3\_transition\_storage\_class) | S3 
storage class to transition access logs of Load Balancer after amount of days | `string` | `"STANDARD_IA"` | no |
| <a name="input_athena_access_logs_s3_db_name"></a> [athena\_access\_logs\_s3\_db\_name](#input\_athena\_access\_logs\_s3\_db\_name) | AWS Athena Database name for ALB 
access logging | `string` | `"alb_logs"` | no |
| <a name="input_athena_access_logs_s3_expiration_days"></a> [athena\_access\_logs\_s3\_expiration\_days](#input\_athena\_access\_logs\_s3\_expiration\_days) | Amount of days for expiration of S3 results of AWS Athena | `number` | `30` | no |
| <a name="input_cross_zone_load_balancing_enabled"></a> [cross\_zone\_load\_balancing\_enabled](#input\_cross\_zone\_load\_balancing\_enabled) | A boolean flag to enable/disable cross zone load balancing | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | A boolean flag to enable/disable deletion protection for Load Balancer | `bool` | `false` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | The amount of time to wait in seconds before changing the state of a deregistering target to unused | `number` | `15` | no |
| <a name="input_enable_access_logs_s3"></a> [enable\_access\_logs\_s3](#input\_enable\_access\_logs\_s3) | A boolean flag to enable/disable load balancing access logs | `bool` | `true` | no |
| <a name="input_enable_athena_access_logs_s3"></a> [enable\_athena\_access\_logs\_s3](#input\_enable\_athena\_access\_logs\_s3) | Enable AWS Athena for ALB access logging analysis | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | A boolean flag to determine whether the Load Balancer should be internal | `bool` | `false` | no |        
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type of Load Balancer | `string` | `"ipv4"` | no |
| <a name="input_listener_maps_list"></a> [listener\_maps\_list](#input\_listener\_maps\_list) | Customize details about the listener, if target of target group(s) is only one instance | `list(map(string))` | `[]` | no |
| <a name="input_listener_maps_list_several_targets"></a> [listener\_maps\_list\_several\_targets](#input\_listener\_maps\_list\_several\_targets) | Customize details about the listener, if targets of target group(s) are more than one instance | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all resources as prefix | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Name of region | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC Subnet IDs to launch in | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_target_group_target_several_targets"></a> [target\_group\_target\_several\_targets](#input\_target\_group\_target\_several\_targets) | Enable if targets of target group(s) are more than one instance | `bool` | `false` | no |
| <a name="input_target_group_target_type"></a> [target\_group\_target\_type](#input\_target\_group\_target\_type) | Target type of target group | `string` | `"instance"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr for security group rules | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | String of vpc id | `string` | n/a | yes |

## Outputs

No outputs.

## Authors

Module managed by [Marcel Emmert](https://github.com/echomike80).

## License

Apache 2 Licensed. See LICENSE for full details.
