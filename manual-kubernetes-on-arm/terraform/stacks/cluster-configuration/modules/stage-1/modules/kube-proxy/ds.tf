resource "kubernetes_daemonset" "this" {
  metadata {
    name      = "kube-proxy"
    namespace = local.namespace
  }
  spec {
    selector {
      match_labels = {
        k8s-app = "kube-proxy"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app = "kube-proxy"
        }
      }
      spec {
        container {
          name  = "kube-proxy"
          image = "k8s.gcr.io/kube-proxy:v${var.kubernetes_version}"

          command = [
            "/usr/local/bin/kube-proxy",
            "--config=/var/lib/kube-proxy/config.conf",
            "--hostname-override=$(NODE_NAME)"
          ]

          env {
            name = "NODE_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.nodeName"
              }
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "50Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "20Mi"
            }
          }

          security_context {
            privileged = true
          }

          volume_mount {
            mount_path = "/var/lib/kube-proxy"
            name       = "kube-proxy"
          }

          volume_mount {
            mount_path = "/run/xtables.lock"
            name       = "xtables-lock"
          }

          volume_mount {
            mount_path = "/lib/modules"
            name       = "lib-modules"
            read_only  = true
          }
        }
        host_network         = true
        priority_class_name  = "system-node-critical"
        service_account_name = kubernetes_service_account.this.metadata[0].name

        toleration {
          operator = "Exists"
        }

        volume {
          name = "kube-proxy"

          config_map {
            name = kubernetes_config_map.this.metadata[0].name
          }
        }

        volume {
          name = "xtables-lock"

          host_path {
            path = "/run/xtables.lock"
            type = "FileOrCreate"
          }
        }

        volume {
          name = "lib-modules"

          host_path {
            path = "/lib/modules"
            type = ""
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [metadata.0.resource_version]
  }
}
