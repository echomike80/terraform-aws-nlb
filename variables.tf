variable "access_logs_s3_bucket_name" {
  description = "Name of the S3 bucket for access logs of Load Balancer"
  type        = string
  default     = null
}

variable "access_logs_s3_expiration_days" {
  description = "Amount of days for expiration of S3 access logs of Load Balancer"
  type        = number
  default     = 90
}

variable "access_logs_s3_transition_days" {
  description = "Amount of days for S3 storage class to transition of access logs of Load Balancer"
  type        = number
  default     = 30
}

variable "access_logs_s3_transition_storage_class" {
  description = "S3 storage class to transition access logs of Load Balancer after amount of days"
  type        = string
  default     = "STANDARD_IA" # or "ONEZONE_IA"
}

variable "athena_access_logs_s3_db_name" {
  description = "AWS Athena Database name for ALB access logging"
  type        = string
  default     = "alb_logs"
}

variable "athena_access_logs_s3_expiration_days" {
  description = "Amount of days for expiration of S3 results of AWS Athena"
  type        = number
  default     = 30
}

variable "cross_zone_load_balancing_enabled" {
  description = "A boolean flag to enable/disable cross zone load balancing"
  type        = bool
  default     = true
}

variable "deletion_protection_enabled" {
  description = "A boolean flag to enable/disable deletion protection for Load Balancer"
  type        = bool
  default     = false
}

variable "deregistration_delay" {
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
  type        = number
  default     = 15
}

variable "enable_access_logs_s3" {
  description = "A boolean flag to enable/disable load balancing access logs"
  type        = bool
  default     = true
}

variable "enable_athena_access_logs_s3" {
  description = "Enable AWS Athena for ALB access logging analysis"
  type        = bool
  default     = false
}

variable "internal" {
  description = "A boolean flag to determine whether the Load Balancer should be internal"
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "IP address type of Load Balancer"
  type        = string
  default     = "ipv4"
}

variable "listener_maps_list" {
  description = "Customize details about the listener, if target of target group(s) is only one instance"
  type        = list(map(string))
  default     = []
}

variable "listener_maps_list_several_targets" {
  description = "Customize details about the listener, if targets of target group(s) are more than one instance"
  type        = list(any)
  default     = []
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

variable "region" {
  description = "Name of region"
  type        = string
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

## ToDo improvement 
## - https://github.com/hashicorp/terraform-provider-aws/pull/11404
## - https://stackoverflow.com/questions/49284508/dynamic-subnet-mappings-for-aws-lb/57760953
## - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnet_mapping
# variable "subnet_mapping_subnet_ids" {
#   description = "A list of VPC Subnet IDs to launch in subnet_mapping"
#   type        = list(string)
#   default     = []
# }

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "target_group_target_several_targets" {
  description = "Enable if targets of target group(s) are more than one instance"
  type        = bool
  default     = false
}

variable "target_group_target_type" {
  description = "Target type of target group"
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "String of vpc id"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr for security group rules"
  type        = string
  default     = "10.0.0.0/16"
}