variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "nacl_name" {
  type = string
  description = "NACL Name"
}

variable "public_subnet_id" {
  type = string
}

variable "public_nacl_ingress_rules" {
  description = "Ingress rules for public NACL"
  type        = list(object({
    rule_number = number
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_block  = string
    rule_action = string
  }))
}

variable "public_nacl_egress_rules" {
  description = "Egress rules for public NACL"
  type        = list(object({
    rule_number = number
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_block  = string
    rule_action = string
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}