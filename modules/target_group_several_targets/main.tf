resource "aws_lb_target_group" "several_targets" {
  name                  = var.name
  vpc_id                = var.vpc_id
  port                  = var.listener_map_several_targets.target_group_port
  protocol              = var.listener_map_several_targets.target_group_protocol
  target_type           = var.target_group_target_type
  deregistration_delay  = var.deregistration_delay

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "several_targets" {
  count             = length(var.listener_map_several_targets.target_ids)
  target_group_arn  = aws_lb_target_group.several_targets.arn
  target_id         = var.listener_map_several_targets.target_ids[count.index]
  port              = var.listener_map_several_targets.target_group_port
}

resource "aws_lb_listener" "several_targets" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_map_several_targets.listener_port
  protocol          = var.listener_map_several_targets.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.several_targets.arn
  }
}