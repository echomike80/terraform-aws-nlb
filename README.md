# AWS application load balancer Terraform module

Terraform module which creates a network load balancer with multiple listeners and target groups on AWS.

## Terraform versions

Terraform 0.12 and newer. 

## Usage

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

  listener_maps_list                    =  [
    {
      listener_port             = var.listener_port_ssh_1
      listener_protocol         = "TCP"
      target_group_port         = var.target_group_port_ssh_1
      target_group_protocol     = "TCP"
      target_ids                = var.instance_id_1
    },
    {
      listener_port             = var.listener_port_ssh_2
      listener_protocol         = "TCP"
      target_group_port         = var.target_group_port_ssh_2
      target_group_protocol     = "TCP"
      target_ids                = var.instance_id_2
    },
    {
      listener_port             = var.listener_port_ssh_3
      listener_protocol         = "TCP"
      target_group_port         = var.target_group_port_ssh_3
      target_group_protocol     = "TCP"
      target_ids                = var.instance_id_3
    },
    ...
    ...
    ...
  ]

  enable_athena_access_logs_s3          = true
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
| terraform | >= 0.12.6 |
| aws | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.65 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_logs\_s3\_expiration\_days | Amount of days for expiration of S3 access logs of Load Balancer | `number` | `90` | no |
| access\_logs\_s3\_transition\_days | Amount of days for S3 storage class to transition of access logs of Load Balancer | `number` | `30` | no |
| access\_logs\_s3\_transition\_storage\_class | S3 storage class to transition access logs of Load Balancer after amount of days | `string` | `"STANDARD_IA"` | no |
| athena\_access\_logs\_s3\_db\_name | AWS Athena Database name for ALB access logging | `string` | `"alb_logs"` | no |
| athena\_access\_logs\_s3\_expiration\_days | Amount of days for expiration of S3 results of AWS Athena | `number` | `30` | no |
| cross\_zone\_load\_balancing\_enabled | A boolean flag to enable/disable cross zone load balancing | `bool` | `true` | no |
| deletion\_protection\_enabled | A boolean flag to enable/disable deletion protection for Load Balancer | `bool` | `false` | no |
| deregistration\_delay | The amount of time to wait in seconds before changing the state of a deregistering target to unused | `number` | `15` | no |
| enable\_athena\_access\_logs\_s3 | Enable AWS Athena for ALB access logging analysis | `bool` | `false` | no |
| internal | A boolean flag to determine whether the Load Balancer should be internal | `bool` | `false` | no |
| ip\_address\_type | IP address type of Load Balancer | `string` | `"ipv4"` | no |
| listener\_maps\_list | Customize details about the listener | `list(map(string))` | `[]` | no |
| name | Name to be used on all resources as prefix | `string` | n/a | yes |
| region | Name of region | `string` | n/a | yes |
| subnet\_ids | A list of VPC Subnet IDs to launch in | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| target\_group\_target\_type | Target type of target group | `string` | `"instance"` | no |
| vpc\_cidr | VPC cidr for security group rules | `string` | `"10.0.0.0/16"` | no |
| vpc\_id | String of vpc id | `string` | n/a | yes |

## Outputs

No output.

## Authors

Module managed by [Marcel Emmert](https://github.com/echomike80).

## License

Apache 2 Licensed. See LICENSE for full details.
