resource "helm_release" "this" {
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [jsonencode({
    args = [
      "--requestheader-client-ca-file=/var/run/kubernetes.io/extension-apiserver-authentication/requestheader-client-ca-file"
    ]

    nodeSelector = {
      "role" = "infra"
    }

    tolerations = [
      {
        key    = "node-role.kubernetes.io/infra"
        effect = "NoSchedule"
      }
    ]

    resources = {
      requests = {
        cpu    = "100m"
        memory = "200Mi"
      }
    }

    # https://github.com/kubernetes-sigs/metrics-server/blob/master/KNOWN_ISSUES.md#incorrectly-configured-front-proxy-certificate
    extraVolumes = [{
      name = "front-proxy-ca"
      configMap = {
        name = "extension-apiserver-authentication"
      }
    }]
    extraVolumeMounts = [{
      name      = "front-proxy-ca"
      mountPath = "/var/run/kubernetes.io/extension-apiserver-authentication/"
    }]
  })]
}

