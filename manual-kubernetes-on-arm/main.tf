locals {
  project  = "jkr-manual-k8s"
  vpc_cidr = "10.110.0.0/16"

  # https://github.com/kubernetes/kubernetes/blob/02f7f0b66a8ae3f24ab1f9b072b8f9d1201a7ced/cmd/kubeadm/app/constants/constants.go#L304
  etcd_version       = "3.5.1"
  kubernetes_version = "1.23.4"

  pod_cidr     = local.vpc_cidr
  service_cidr = "172.16.0.0/16"
}
