variable "name" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "autoscale_group_names" {
  type = list(string)
}
