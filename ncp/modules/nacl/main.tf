resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  tags = merge({
    Name = var.nacl_name
  }, var.tags)
}

resource "aws_network_acl_rule" "public_ingress" {
  for_each = {
    for rule in var.public_nacl_ingress_rules : rule.rule_number => rule
  }

  network_acl_id = aws_network_acl.public.id
  egress         = false
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "public_egress" {
  for_each = {
    for rule in var.public_nacl_egress_rules : rule.rule_number => rule
  }

  network_acl_id = aws_network_acl.public.id
  egress         = true
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_association" "public" {
  subnet_id      = var.public_subnet_id
  network_acl_id = aws_network_acl.public.id
}