locals {
  files_kubernetes_configs = {
    "/etc/kubernetes/admin.conf" = {
      user  = "root"
      group = "root"
      mode  = "0600"
      content = yamlencode({
        apiVersion  = "v1"
        kind        = "Config"
        preferences = {}
        clusters = [{
          name = "kubernetes"
          cluster = {
            server                     = "https://${var.kubernetes_api_hostname}:6443"
            certificate-authority-data = base64encode(module.pki_kubernetes.ca_crt)
          }
        }],
        contexts = [{
          name = "kubernetes-admin@kubernetes"
          context = {
            cluster = "kubernetes"
            user    = "kubernetes-admin"
          }
        }]
        current-context = "kubernetes-admin@kubernetes"
        users = [{
          name = "kubernetes-admin"
          user = {
            client-certificate-data = base64encode(module.pki_kubernetes.admin_crt)
            client-key-data         = base64encode(module.pki_kubernetes.admin_key)
          }
        }]
      })
    }
    "/etc/kubernetes/bootstrap-kubelet.conf" = {
      user  = "root"
      group = "root"
      mode  = "0600"
      content = yamlencode({
        apiVersion  = "v1"
        kind        = "Config"
        preferences = {}
        clusters = [{
          name = "kubernetes"
          cluster = {
            server                     = "https://${var.kubernetes_api_hostname}:6443"
            certificate-authority-data = base64encode(module.pki_kubernetes.ca_crt)
          }
        }],
        contexts = [{
          name = "kubelet@kubernetes"
          context = {
            cluster = "kubernetes"
            user    = "kubelet"
          }
        }]
        current-context = "kubelet@kubernetes"
        users = [{
          name = "kubelet"
          user = {
            token = "${module.pki_kubernetes.bootstrap_token_id}.${module.pki_kubernetes.bootstrap_token_secret}"
          }
        }]
      })
    }
    "/etc/kubernetes/controller-manager.conf" = {
      user  = "root"
      group = "root"
      mode  = "0600"
      content = yamlencode({
        apiVersion  = "v1"
        kind        = "Config"
        preferences = {}
        clusters = [{
          name = "kubernetes"
          cluster = {
            server                     = "https://${var.kubernetes_api_hostname}:6443"
            certificate-authority-data = base64encode(module.pki_kubernetes.ca_crt)
          }
        }],
        contexts = [{
          name = "system:kube-controller-manager@kubernetes"
          context = {
            cluster = "kubernetes"
            user    = "system:kube-controller-manager"
          }
        }]
        current-context = "system:kube-controller-manager@kubernetes"
        users = [{
          name = "system:kube-controller-manager"
          user = {
            client-certificate-data = base64encode(module.pki_kubernetes.controller_manager_crt)
            client-key-data         = base64encode(module.pki_kubernetes.controller_manager_key)
          }
        }]
      })
    }
    "/etc/kubernetes/scheduler.conf" = {
      user  = "root"
      group = "root"
      mode  = "0600"
      content = yamlencode({
        apiVersion  = "v1"
        kind        = "Config"
        preferences = {}
        clusters = [{
          name = "kubernetes"
          cluster = {
            server                     = "https://${var.kubernetes_api_hostname}:6443"
            certificate-authority-data = base64encode(module.pki_kubernetes.ca_crt)
          }
        }],
        contexts = [{
          name = "system:kube-scheduler@kubernetes"
          context = {
            cluster = "kubernetes"
            user    = "system:kube-scheduler"
          }
        }]
        current-context = "system:kube-scheduler@kubernetes"
        users = [{
          name = "system:kube-scheduler"
          user = {
            client-certificate-data = base64encode(module.pki_kubernetes.scheduler_crt)
            client-key-data         = base64encode(module.pki_kubernetes.scheduler_key)
          }
        }]
      })
    }
  }

  files_kubernetes_static_manifests = {
    for name, options in local.controllers : name => {
      for filename, manifest in module.kubernetes_static_manifests[name].manifests : "/etc/kubernetes/manifests/${filename}" => {
        user    = "root"
        group   = "root"
        mode    = "0600"
        content = manifest
      }
    }
  }
}

module "kubernetes_static_manifests" {
  for_each = local.etcd_peers

  source = "./modules/kubernetes/static-manifests"

  etcd_version          = var.etcd_version
  etcd_discovery_domain = local.etcd_domain
  etcd_peer_name        = each.value

  cluster_name = var.cluster_name

  service_cidr       = var.service_cidr
  kubernetes_version = var.kubernetes_version
  oidc_issuer_url    = var.kubernetes_oidc_issuer_url

  kms_secret_encryption_arn = aws_kms_key.this.arn
}
