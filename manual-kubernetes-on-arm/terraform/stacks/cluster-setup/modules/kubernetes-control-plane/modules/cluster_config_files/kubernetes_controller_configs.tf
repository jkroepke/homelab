locals {
  files_controller_configs = {
    for controller_name, etcd_peer_name in local.etcd_peer_names : controller_name => merge({
      for filename in fileset("${path.module}/resources/", "etc/kubernetes/**/*.yaml") : "/${filename}" => {
        mode  = 644
        user  = "root"
        group = "root"

        content = templatefile("${path.module}/resources/${filename}", {
          region                    = data.aws_region.current.name
          kms_secret_encryption_arn = var.kms_secret_encryption_arn
          controller_count          = length(var.kubernetes_controllers)

          etcd_discovery_domain = var.etcd_discovery_domain
          etcd_peer_name        = etcd_peer_name
          etcd_version          = var.etcd_version

          kubernetes_version      = var.kubernetes_version
          kubernetes_api_hostname = var.kubernetes_api_hostname
          kubernetes_service_cidr = var.kubernetes_service_cidr
          kubernetes_pod_cidr     = var.kubernetes_pod_cidr

          cluster_name = var.cluster_name
          cluster_dns  = var.cluster_dns
        })
      }
      }, {
      for filename, options in local.kubeconfig : "/etc/kubernetes/${filename}.conf" => {
        user    = "root"
        group   = "root"
        mode    = 600
        content = module.kubeconfig[filename].rendered
      }
    })
  }
  files_kubelet_bootstrap_config = {
    "/etc/kubernetes/bootstrap-kubelet.conf" = {
      user    = "root"
      group   = "root"
      mode    = 600
      content = module.kubeconfig["bootstrap-kubelet"].rendered
    }
  }
}


