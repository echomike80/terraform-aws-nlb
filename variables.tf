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

variable "enable_any_egress_to_vpc" {
  description = "Enable any egress traffic from Load Balancer instance to VPC"
  type        = bool
  default     = true
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

variable "load_balancer_type" {
  description = "Type of Load Balancer"
  type        = string
  default     = "network"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

variable "region" {
  description = "Name of region"
  type        = string
}

variable "sg_rules_egress_cidr_map" {
  description = "Map of security group rules for egress communication of cidr"
  type        = map
  default     = {}
}

variable "sg_rules_ingress_cidr_map" {
  description = "Map of security group rules for ingress communication of cidr"
  type        = map
  default     = {}
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "target_group_health_check_interval" {
  description = "Interval of target group health check"
  type        = string
  default     = "30"
}

variable "target_group_health_check_path" {
  description = "Path of target group health check"
  type        = string
  default     = "/"
}

variable "target_group_health_check_port" {
  description = "Port of target group health check"
  type        = string
  default     = "80"
}

variable "target_group_health_check_healthy_threshold" {
  description = "Healthy threshold of target group health check"
  type        = string
  default     = "3"
}

variable "target_group_health_check_unhealthy_threshold" {
  description = "Unhealthy threshold of target group health check"
  type        = string
  default     = "2"
}

variable "target_group_health_check_timeout" {
  description = "Timeout of target group health check"
  type        = string
  default     = "5"
}

variable "target_group_health_check_protocol" {
  description = "Protocol of target group health check"
  type        = string
  default     = "HTTP"
}

variable "target_group_health_check_matcher" {
  description = "Matcher of target group health check"
  type        = string
  default     = "200"
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