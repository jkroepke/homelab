variable "kubernetes_server" {
  type = string
}
variable "kubernetes_ca" {
  type = string
}
variable "user" {
  type = string
}
variable "user_auth" {
  type = map(string)
}
