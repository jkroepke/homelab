variable "name" {
  type = string
}

variable "policy_arns" {
  default = []
  type    = list(string)
}

variable "policy_json" {
  default = ""
  type    = string
}

variable "issuer" {
  type = string
}

variable "sub" {
  type = list(string)
}
