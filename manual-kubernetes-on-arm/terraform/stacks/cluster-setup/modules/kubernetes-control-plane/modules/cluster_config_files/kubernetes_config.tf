locals {
  kubeconfig = {
    admin = {
      user = "kubernetes-admin"
      user_auth = {
        client-certificate-data = base64encode(module.pki_kubernetes.admin_crt)
        client-key-data         = base64encode(module.pki_kubernetes.admin_key)
      }
    }
    bootstrap-kubelet = {
      user = "kubelet"
      user_auth = {
        token = "${module.pki_kubernetes.bootstrap_token_id}.${module.pki_kubernetes.bootstrap_token_secret}"
      }
    }
    controller-manager = {
      user = "system:kube-controller-manager"
      user_auth = {
        client-certificate-data = base64encode(module.pki_kubernetes.controller_manager_crt)
        client-key-data         = base64encode(module.pki_kubernetes.controller_manager_key)
      }
    }
    scheduler = {
      user = "system:kube-scheduler"
      user_auth = {
        client-certificate-data = base64encode(module.pki_kubernetes.scheduler_crt)
        client-key-data         = base64encode(module.pki_kubernetes.scheduler_key)
      }
    }
  }
}

module "kubeconfig" {
  for_each = local.kubeconfig

  source = "../../../../../../modules/kubeconfig"

  kubernetes_ca     = base64encode(module.pki_kubernetes.ca_crt)
  kubernetes_server = "https://${var.kubernetes_api_hostname}"
  user              = each.value.user
  user_auth         = each.value.user_auth
}
