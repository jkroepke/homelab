variable "cluster_name" {
  type = string
}

variable "name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "etcd_peer_name" {
  type = string
}

variable "etcd_route53_zone_id" {
  type = string
}

variable "etcd_volume_size" {
  default = 10
  type    = number
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "lb_target_group_arn" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "user_data" {
  type = string
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "vpc_security_group_ids" {
  type = list(string)
}
