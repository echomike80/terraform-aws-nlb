output "security_group_id_lb" {
  description = "ID of security group to use for the Load Balancer"
  value = var.load_balancer_type != "network" ? aws_security_group.this[0].id : null
}