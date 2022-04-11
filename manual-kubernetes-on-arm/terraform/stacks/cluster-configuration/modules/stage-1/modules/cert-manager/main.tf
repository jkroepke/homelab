resource "kubernetes_namespace" "this" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "this" {
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      installCRDs = true

      nodeSelector = {
        "node-role.kubernetes.io/master" = ""
      }

      extraArgs = ["--enable-certificate-owner-ref=true"]

      tolerations = [
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      ]

      resources = {
        requests = {
          cpu    = "10m"
          memory = "32Mi"
        }
      }

      webhook = {
        nodeSelector = {
          "node-role.kubernetes.io/master" = ""
        }

        tolerations = [
          {
            key    = "node-role.kubernetes.io/master"
            effect = "NoSchedule"
          }
        ]

        resources = {
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
        }
      }

      cainjector = {
        nodeSelector = {
          "node-role.kubernetes.io/master" = ""
        }

        tolerations = [
          {
            key    = "node-role.kubernetes.io/master"
            effect = "NoSchedule"
          }
        ]

        resources = {
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
        }
      }

      startupapicheck = {
        nodeSelector = {
          "node-role.kubernetes.io/master" = ""
        }
        tolerations = [
          {
            key    = "node-role.kubernetes.io/master"
            effect = "NoSchedule"
          }
        ]
      }
    })
  ]
}

