variable "name" {
  type = string
}

variable "versions" {
  type = map(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "kubernetes" {
  type = map(string)
}
