locals {
  controller_pki_files = merge(
  {
    "etc/etcd/ca.key"     = tls_private_key.etcd-key["etcd-ca"].private_key_pem
    "etc/etcd/ca.crt"     = tls_self_signed_cert.etcd-ca.cert_pem
    "etc/etcd/server.key" = tls_private_key.etcd-key["etcd-server"].private_key_pem
    "etc/etcd/server.crt" = tls_locally_signed_cert.etcd-crt["etcd-server"].cert_pem
    "etc/etcd/peer.key"   = tls_private_key.etcd-key["etcd-peer"].private_key_pem
    "etc/etcd/peer.crt"   = tls_locally_signed_cert.etcd-crt["etcd-peer"].cert_pem

    "etc/kubernetes/apiserver-kubelet-client.key" = tls_private_key.etcd-key["apiserver-kubelet-client"].private_key_pem
    "etc/kubernetes/apiserver-kubelet-client.crt" = tls_locally_signed_cert.etcd-crt["apiserver-kubelet-client"].cert_pem

    "etc/kubernetes/ca.key" = tls_private_key.kubernetes-key["kubernetes-ca"].private_key_pem
    "etc/kubernetes/ca.crt" = tls_self_signed_cert.kubernetes-ca.cert_pem

    "etc/kubernetes/front-proxy-ca.key" = tls_private_key.front-proxy-key["front-proxy-ca"].private_key_pem
    "etc/kubernetes/front-proxy-ca.crt" = tls_self_signed_cert.front-proxy-ca.cert_pem
  },
  {for cert in keys(local.kubernetes_certificates): "etc/kubernetes/${cert}.key" => tls_private_key.kubernetes-key[cert].private_key_pem},
  {for cert in keys(local.kubernetes_certificates): "etc/kubernetes/${cert}.crt" => tls_locally_signed_cert.kubernetes-crt[cert].cert_pem},
  {for cert in keys(local.front-proxy_certificates): "etc/kubernetes/${cert}.key" => tls_private_key.front-proxy-key[cert].private_key_pem},
  {for cert in keys(local.front-proxy_certificates): "etc/kubernetes/${cert}.crt" => tls_locally_signed_cert.front-proxy-crt[cert].cert_pem}
  )
}

resource "aws_s3_bucket_object" "controller" {
  for_each = local.controller_pki_files

  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = "controller/${each.key}"
  content = each.value

  etag = md5(each.value)
}
