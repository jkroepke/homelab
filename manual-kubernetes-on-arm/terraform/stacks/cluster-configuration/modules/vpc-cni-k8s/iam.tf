data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy"
}
/*
module "iam_role" {
  source = "../../../../modules/iam-role-for-service-account"

  name        = "${var.cluster_name}-vpc-cni-k8s"
  issuer      = replace(var.kubernetes_api_server, "https://", "")
  policy_arns = [data.aws_iam_policy.AmazonEKS_CNI_Policy.arn]
  sub         = ["system:serviceaccount:kube-system:aws-vpc-cni"]
}
*/
