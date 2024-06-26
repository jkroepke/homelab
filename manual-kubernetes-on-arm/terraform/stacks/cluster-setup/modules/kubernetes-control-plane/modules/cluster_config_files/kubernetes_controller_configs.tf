locals {
  files_controller_configs = { for controller_name, etcd_peer_name in local.etcd_peer_names : controller_name => merge({
    for filename in fileset("${path.module}/resources/", "etc/kubernetes/**/*.yaml") : "/${filename}" => {
      mode  = "0644"
      user  = "root"
      group = "root"

      content = templatefile("${path.module}/resources/${filename}", {
        cluster_name = var.cluster_name

        region                    = data.aws_region.current.name
        kms_secret_encryption_arn = var.kms_secret_encryption_arn
        controller_count          = length(var.kubernetes_controllers)

        etcd_discovery_domain = var.etcd_discovery_domain
        etcd_peer_name        = etcd_peer_name
        etcd_version          = var.etcd_version

        kubernetes_version      = var.kubernetes_version
        kubernetes_api_hostname = var.kubernetes_api_hostname
        kubernetes_oidc_issuer  = var.kubernetes_oidc_issuer
        kubernetes_service_cidr = var.kubernetes_service_cidr
        kubernetes_pod_cidr     = var.kubernetes_pod_cidr
      })
    } },
    {
      for filename, options in local.kubeconfig : "/etc/kubernetes/${filename}.conf" => {
        user    = "root"
        group   = "root"
        mode    = "0600"
        content = module.kubeconfig[filename].rendered
      }
    },
    {
      "/var/lib/kubelet/config.yaml" = {
        user  = "root"
        group = "root"
        mode  = "0600"
        content = templatefile("${path.module}/resources/var/lib/kubelet/config.yaml", {
          controller             = true
          kubernetes_cluster_dns = var.kubernetes_cluster_dns
          kubernetes_pod_cidr    = var.kubernetes_pod_cidr
        })
      }
    }
    )
  }
}


