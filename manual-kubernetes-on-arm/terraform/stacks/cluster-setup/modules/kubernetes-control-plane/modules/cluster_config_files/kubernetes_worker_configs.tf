locals {
  files_worker_configs = {
    "/etc/kubernetes/pki/ca.crt" = {
      content = module.pki_kubernetes.ca_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/bootstrap-kubelet.conf" = {
      content = module.kubeconfig["bootstrap-kubelet"].rendered
      user    = "root"
      group   = "root"
      mode    = "0600"
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
