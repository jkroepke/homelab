resource "kubernetes_manifest" "provisioner_infra" {
  manifest = yamldecode(<<EOF
---
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: infra
spec:
  taints:
    - key: node-role.kubernetes.io/infra
      effect: NoSchedule
  labels:
    role: "infra"
  requirements:
    - key: "node.kubernetes.io/instance-type"
      operator: In
      values: ["t4g.small", "t4g.medium", "t4g.large", "t4g.2xlarge"]
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
    - key: "kubernetes.io/arch"
      operator: In
      values: ["arm64"]
  limits:
    resources:
      cpu: 10
  provider:
    launchTemplate: ${var.cluster_name}-node
    subnetSelector:
      project: ${var.cluster_name}
      karpenter.sh/discovery: ${var.cluster_name}
      kubernetes.io/role/internal-elb: "1"
    tags:
      Name: ${var.cluster_name}-node-infra
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000
EOF
  )

  depends_on = [helm_release.this]
}

resource "kubernetes_manifest" "provisioner_default" {
  manifest = yamldecode(<<EOF
---
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: "node.kubernetes.io/instance-type"
      operator: In
      values: ["t4g.small", "t4g.medium", "t4g.large", "t4g.2xlarge"]
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
    - key: "kubernetes.io/arch"
      operator: In
      values: ["arm64"]
  limits:
    resources:
      cpu: 10
  provider:
    launchTemplate: ${var.cluster_name}-node
    subnetSelector:
      project: ${var.cluster_name}
      karpenter.sh/discovery: ${var.cluster_name}
      kubernetes.io/role/internal-elb: "1"
    tags:
      Name: ${var.cluster_name}-node-default
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000
EOF
  )

  depends_on = [helm_release.this]
}
