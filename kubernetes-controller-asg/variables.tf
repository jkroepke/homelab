variable "project" {
  default = "jkr-k8s-controller-asg"
}

variable "worker_count" {
  default = 1
  type    = number
}
