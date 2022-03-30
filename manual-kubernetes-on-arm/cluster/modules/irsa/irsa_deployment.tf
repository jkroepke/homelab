resource "kubernetes_deployment" "this" {
  metadata {
    name      = "pod-identity-webhook"
    namespace = local.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "pod-identity-webhook"
      }
    }
    template {
      metadata {
        labels = {
          app = "pod-identity-webhook"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.this.metadata[0].name
        container {
          name  = "pod-identity-webhook"
          image = "IMAGE"
          command = [
            "/webhook",
            "--in-cluster=false",
            "--namespace=${local.namespace}",
            "--service-name=pod-identity-webhook",
            "--annotation-prefix=eks.amazonaws.com",
            "--token-audience=sts.amazonaws.com",
            "--logtostderr"
          ]
          volume_mount {
            mount_path = "/etc/webhook/certs"
            name       = "cert"
            read_only  = true
          }
        }
        volume {
          name = "cert"
          secret {
            secret_name = "pod-identity-webhook-cert"
          }
        }
      }
    }
  }
}

