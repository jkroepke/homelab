variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "etcd_peer_name" {
  type = string
}

variable "lb_target_group_arn" {
  type = string
}

variable "user_data" {
  type = string
}

variable "vpc_security_group_id" {
  type = string
}
