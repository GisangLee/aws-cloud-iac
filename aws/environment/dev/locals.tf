locals {
  public_nacl_ingress_rules = [
    {
      rule_number = 100
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
      rule_action = "allow"
    },
    {
      rule_number = 110
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
      rule_action = "allow"
    }
  ]

  public_nacl_egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_block  = "0.0.0.0/0"
      rule_action = "allow"
    }
  ]
}