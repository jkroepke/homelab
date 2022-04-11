resource "helm_release" "this" {
  repository = "https://docs.projectcalico.org/charts"
  chart      = "tigera-operator"
  name       = "tigera-operator"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300


  values = [jsonencode({
    installation = {
      componentResources = [{
        componentName = "KubeControllers"
        resourceRequirements = {
          limits = {
            memory = "50Mi"
          }
          requests = {
            memory = "10Mi"
          }
        }
        }, {
        componentName = "Typha"
        resourceRequirements = {
          limits = {
            memory = "50Mi"
          }
          requests = {
            memory = "30Mi"
          }
        }
        }, {
        componentName = "Node"
        resourceRequirements = {
          limits = {
            memory = "200Mi"
          }
          requests = {
            memory = "100Mi"
          }
        }
      }]

      cni = {
        type = "AmazonVPC"
      }

      controlPlaneTolerations = [
        {
          key    = "node-role.kubernetes.io/infra"
          effect = "NoSchedule"
        }
      ]

      controlPlaneNodeSelector = {
        "role" = "infra"
      }

      flexVolumePath = "/opt/libexec/kubernetes/kubelet-plugins/volume/exec/"
    }
  })]
}

