locals {
  files_worker_configs = {
    "/etc/kubernetes/bootstrap-kubelet.conf" = {
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = module.kubeconfig["bootstrap-kubelet"].rendered
    }
    "/var/lib/kubelet/config.yaml" = {
      user  = "root"
      group = "root"
      mode  = "0600"
      content = templatefile("${path.module}/resources/var/lib/kubelet/config.yaml", {
        controller             = false
        kubernetes_cluster_dns = var.kubernetes_cluster_dns
        kubernetes_pod_cidr    = var.kubernetes_pod_cidr
      })
    }
  }
}
