# etcd CA

resource "tls_private_key" "etcd-ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "etcd-ca" {
  key_algorithm   = tls_private_key.etcd-ca.algorithm
  private_key_pem = tls_private_key.etcd-ca.private_key_pem

  subject {
    common_name  = "etcd-ca"
    organization = "etcd"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

# etcd Client (apiserver to etcd communication)
resource "tls_private_key" "apiserver_etcd_client" {
  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "apiserver_etcd_client" {
  key_algorithm   = tls_private_key.apiserver_etcd_client.algorithm
  private_key_pem = tls_private_key.apiserver_etcd_client.private_key_pem

  subject {
    common_name  = "apiserver-etcd-client"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  ip_addresses = [
    "127.0.0.1",
  ]

  dns_names = concat(["localhost"])
}

resource "tls_locally_signed_cert" "apiserver_etcd_client" {
  cert_request_pem = tls_cert_request.apiserver_etcd_client.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.etcd-ca.key_algorithm
  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}


resource "tls_private_key" "healthcheck_client" {
  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "healthcheck_client" {
  key_algorithm   = tls_private_key.healthcheck_client.algorithm
  private_key_pem = tls_private_key.healthcheck_client.private_key_pem

  subject {
    common_name  = "etcd-healthcheck-client"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  ip_addresses = [
    "127.0.0.1",
  ]

  dns_names = concat(["localhost"])
}

resource "tls_locally_signed_cert" "healthcheck_client" {
  cert_request_pem = tls_cert_request.healthcheck_client.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.etcd-ca.key_algorithm
  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

# etcd Server

resource "tls_private_key" "server" {
  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "server" {
  key_algorithm   = tls_private_key.server.algorithm
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "etcd-server"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  ip_addresses = [
    "127.0.0.1"
  ]

  dns_names = concat(["localhost"])
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem = tls_cert_request.server.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.etcd-ca.key_algorithm
  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

# etcd Peer
resource "tls_private_key" "peer" {
  for_each = var.etcd_peers

  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "peer" {
  for_each = var.etcd_peers

  key_algorithm   = tls_private_key.peer[each.key].algorithm
  private_key_pem = tls_private_key.peer[each.key].private_key_pem

  subject {
    common_name  = "etcd-peer"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  dns_names = ["${each.value}.${var.etcd_domain}"]
}

resource "tls_locally_signed_cert" "peer" {
  for_each = var.etcd_peers

  cert_request_pem = tls_cert_request.peer[each.key].cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.etcd-ca.key_algorithm
  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

