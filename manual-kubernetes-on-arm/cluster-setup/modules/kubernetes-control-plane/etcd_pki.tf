module "pki_etcd" {
  source      = "./modules/pki/etcd"
  etcd_domain = local.etcd_domain
  etcd_peers  = local.etcd_peers
}

locals {
  files_pki_etcd = {
    for name, options in local.controllers : name => {
      "/etc/kubernetes/pki/etcd/ca.crt" = {
        content = module.pki_etcd.ca
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/server.key" = {
        content = module.pki_etcd.server_key[name]
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/server.crt" = {
        content = module.pki_etcd.server_crt[name]
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/peer.key" = {
        content = module.pki_etcd.peer_key[name]
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/peer.crt" = {
        content = module.pki_etcd.peer_crt[name]
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/healthcheck-client.key" = {
        content = module.pki_etcd.healthcheck_client_key
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/etcd/healthcheck-client.crt" = {
        content = module.pki_etcd.healthcheck_client_crt
        user    = "etcd"
        group   = "etcd"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/apiserver-etcd-client.key" = {
        content = module.pki_etcd.apiserver_etcd_client_key
        user    = "root"
        group   = "root"
        mode    = "0600"
      }
      "/etc/kubernetes/pki/apiserver-etcd-client.crt" = {
        content = module.pki_etcd.apiserver_etcd_client_crt
        user    = "root"
        group   = "root"
        mode    = "0600"
      }
    }
  }
}