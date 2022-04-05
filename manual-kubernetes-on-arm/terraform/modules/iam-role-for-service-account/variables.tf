variable "name" {
  type = string
}

variable "policy_arns" {
  type = list(string)
}

variable "issuer" {
  type = string
}

variable "sub" {
  type = list(string)
}
