resource "kubernetes_manifest" "provisioner" {
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
      cpu: 1k
  provider:
    amiFamily: Bottlerocket
    subnetSelector:
      project: ${var.cluster_name}
      karpenter.sh/discovery: ${var.cluster_name}
      kubernetes.io/role/internal-elb: "1"
    securityGroupSelector:
      project: ${var.cluster_name}
      Name: ${var.cluster_name}-worker
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000
EOF
  )

  depends_on = [helm_release.this]
}
