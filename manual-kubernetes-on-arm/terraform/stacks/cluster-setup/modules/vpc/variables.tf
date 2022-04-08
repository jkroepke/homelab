variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "public_ipv6_net_id" {
  type = string
}

variable "private_ipv6_net_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
