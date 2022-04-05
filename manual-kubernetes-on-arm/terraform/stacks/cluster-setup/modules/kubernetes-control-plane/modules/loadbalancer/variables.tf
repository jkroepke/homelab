variable "name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "subnets" {
  type = map(string)
}
