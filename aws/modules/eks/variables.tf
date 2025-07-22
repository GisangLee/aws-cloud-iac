variable "cluster_name" {}
variable "kubernetes_version" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "cluster_role_arn" {}
variable "node_role_arn" {}

variable "node_desired_size" {
  type = number
}
variable "node_min_size" {
  type = number
}
variable "node_max_size" {
  type = number
}

variable "instance_types" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_group_name" {
  type = string
}

variable "authentication_mode" {
  type = string
}