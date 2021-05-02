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
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable cross zone load balancing"
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable deletion protection for Load Balancer"
}

variable "deregistration_delay" {
  type        = number
  default     = 15
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}

variable "enable_athena_access_logs_s3" {
  description = "Enable AWS Athena for ALB access logging analysis"
  type        = bool
  default     = false
}

variable "internal" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether the Load Balancer should be internal"
}

variable "ip_address_type" {
  description = "IP address type of Load Balancer"
  type        = string
  default     = "ipv4"
}

variable "listener_maps_list" {
  description = "Customize details about the listener"
  type        = list(map(string))
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