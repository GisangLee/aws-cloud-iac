variable "lb_name" {
  type = string
}

variable "lb_type" {
  type = string
}


variable "tags" {
  type = map(string)
  default = {}
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to attach to the ALB"
  type        = list(string)
}