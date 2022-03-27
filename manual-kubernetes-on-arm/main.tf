locals {
  project  = "jkr-manual-k8s"
  vpc_cidr = "10.110.0.0/16"

  # https://github.com/kubernetes/kubernetes/blob/02f7f0b66a8ae3f24ab1f9b072b8f9d1201a7ced/cmd/kubeadm/app/constants/constants.go#L304
  etcd_version       = "3.5.1"
  kubernetes_version = "1.23.4"

  private_subnet_cidr = cidrsubnet(local.vpc_cidr, 4, 0)
  public_subnet_cidr  = cidrsubnet(local.vpc_cidr, 4, 1)
  service_cidr        = cidrsubnet(local.vpc_cidr, 4, 2)
  pod_cidr            = cidrsubnet(local.vpc_cidr, 4, 3)

  private_ipv6_net_id = 0
  public_ipv6_net_id  = 8
  service_ipv6_net_id = 16
  pod_ipv6_net_id     = 24

  cluster_dns = cidrhost(local.service_cidr, 10)
}
