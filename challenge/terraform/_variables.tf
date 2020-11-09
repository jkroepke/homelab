variable "name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "root_dns_zone" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "versions" {
  type = object({
    ubuntu     = string
    cri-o      = string
    kubernetes = string
    etcd       = string
    calico     = string
  })
}

variable "kubernetes" {
  type = object({
    api_hostname       = string
    service_cidr_block = string
    pod_cidr_block     = string
  })
}
