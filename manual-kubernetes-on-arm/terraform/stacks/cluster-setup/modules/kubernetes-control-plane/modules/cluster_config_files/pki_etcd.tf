module "pki_etcd" {
  source          = "./modules/pki/etcd"
  etcd_domain     = var.etcd_discovery_domain
  etcd_peer_names = local.etcd_peer_names
}

locals {
  files_pki_etcd = {
    for index in keys(var.kubernetes_controllers) : index => {
      "/etc/kubernetes/pki/etcd/ca.crt" = {
        content = module.pki_etcd.ca
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/server.key" = {
        content = module.pki_etcd.server_key[index]
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/server.crt" = {
        content = module.pki_etcd.server_crt[index]
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/peer.key" = {
        content = module.pki_etcd.peer_key[index]
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/peer.crt" = {
        content = module.pki_etcd.peer_crt[index]
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/healthcheck-client.key" = {
        content = module.pki_etcd.healthcheck_client_key
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/etcd/healthcheck-client.crt" = {
        content = module.pki_etcd.healthcheck_client_crt
        user    = "etcd"
        group   = "etcd"
        mode    = 600
      }
      "/etc/kubernetes/pki/apiserver-etcd-client.key" = {
        content = module.pki_etcd.apiserver_etcd_client_key
        user    = "root"
        group   = "root"
        mode    = 600
      }
      "/etc/kubernetes/pki/apiserver-etcd-client.crt" = {
        content = module.pki_etcd.apiserver_etcd_client_crt
        user    = "root"
        group   = "root"
        mode    = 600
      }
    }
  }
}
