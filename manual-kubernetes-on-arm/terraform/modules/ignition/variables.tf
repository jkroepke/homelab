variable "name" {
  type = string
}

variable "snippets" {
  type = list(string)
}

variable "files" {
  type = map(object({ content = string, user = string, group = string, mode = number }))
}
