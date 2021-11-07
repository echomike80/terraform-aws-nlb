variable "deregistration_delay" {
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
  type        = number
  default     = 15
}

variable "listener_map_several_targets" {
  description = "Customize details about the listener"
#   type        = map(any)
#   default     = {}
}

variable "load_balancer_arn" {
  description = "Load Balancer ARN"
  type        = string
  default     = null
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

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