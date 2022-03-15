/*
module "k8s_bootstrap" {
  source = "./modules/kubernetes-bootstrap"
  api_servers = []
  etcd_servers = []
  cluster_name = local.project

  service_cidr = "172.16.0.0/16"
  pod_cidr = local.pod_cidr

  container_images = {
    kube_apiserver          = "k8s.gcr.io/kube-apiserver:v${local.kubernetes_version}"
    kube_controller_manager = "k8s.gcr.io/kube-controller-manager:v${local.kubernetes_version}"
    kube_scheduler          = "k8s.gcr.io/kube-scheduler:v${local.kubernetes_version}"
    kube_proxy              = "k8s.gcr.io/kube-proxy:v${local.kubernetes_version}"
  }
}
*/
