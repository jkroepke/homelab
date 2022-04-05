module "pki_kubernetes" {
  source                  = "./modules/pki/kubernetes"
  kubernetes_api_hostname = var.kubernetes_api_hostname
  kubernetes_service_cidr = var.kubernetes_service_cidr
}

locals {
  # https://kubernetes.io/docs/setup/best-practices/certificates/
  files_pki_kubernetes = {
    "/etc/kubernetes/pki/ca.crt" = {
      content = module.pki_kubernetes.ca_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/ca.key" = {
      content = module.pki_kubernetes.ca_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }

    "/etc/kubernetes/pki/front-proxy-ca.crt" = {
      content = module.pki_kubernetes.front_proxy_ca_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/front-proxy-ca.key" = {
      content = module.pki_kubernetes.front_proxy_ca_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }

    "/etc/kubernetes/pki/apiserver-kubelet-client.crt" = {
      content = module.pki_kubernetes.apiserver_kubelet_client_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/apiserver-kubelet-client.key" = {
      content = module.pki_kubernetes.apiserver_kubelet_client_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }

    "/etc/kubernetes/pki/apiserver.crt" = {
      content = module.pki_kubernetes.apiserver_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/apiserver.key" = {
      content = module.pki_kubernetes.apiserver_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }

    "/etc/kubernetes/pki/front-proxy-client.crt" = {
      content = module.pki_kubernetes.front_proxy_client_crt
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/front-proxy-client.key" = {
      content = module.pki_kubernetes.front_proxy_client_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }

    "/etc/kubernetes/pki/sa.pub" = {
      content = module.pki_kubernetes.sa_pub
      user    = "root"
      group   = "root"
      mode    = "0644"
    }
    "/etc/kubernetes/pki/sa.key" = {
      content = module.pki_kubernetes.sa_key
      user    = "root"
      group   = "root"
      mode    = "0600"
    }
  }
}
