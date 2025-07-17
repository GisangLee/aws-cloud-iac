resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = true

  tags = merge({
    Name = var.lb_name
  }, var.tags)
}