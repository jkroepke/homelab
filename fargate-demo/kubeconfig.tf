resource "local_file" "kubeconfig" {
  filename = pathexpand("~/.kube/config_eks_demo")

  file_permission = "0640"

  content = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
    server: ${module.eks.cluster_endpoint}
  name: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
contexts:
- context:
    cluster: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
    user: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
  name: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
current-context: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
kind: Config
preferences: {}
users:
- name: arn:aws:eks:${data.aws_region.this.id}:${data.aws_caller_identity.this.account_id}:cluster/${var.project}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - --region
        - ${data.aws_region.this.id}
        - eks
        - get-token
        - --cluster-name
        - ${var.project}
      env:
        - name: "AWS_PROFILE"
          value: "cdt"
KUBECONFIG
}
