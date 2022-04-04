variable "project" {
  default = "jkr-k8s-asg-lambda"
}

variable "worker_count" {
  default = 3
  type    = number
}
