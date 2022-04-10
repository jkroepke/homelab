variable "name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "files" {
  type = map(object({ content = string, user = string, group = string, mode = string }))
}
