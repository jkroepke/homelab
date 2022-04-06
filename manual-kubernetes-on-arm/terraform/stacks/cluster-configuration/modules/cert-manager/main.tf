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
  version    = "v1.7.2"

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

