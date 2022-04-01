resource "kubernetes_namespace" "this" {
  metadata {
    name = var.name
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = kubernetes_namespace.this.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}

resource "kubernetes_deployment" "this" {
  wait_for_rollout = false

  metadata {
    name      = var.name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        service_account_name = kubernetes_service_account.this.metadata[0].name
        container {
          name    = "aws"
          image   = "registry.ipv6.docker.com/amazon/aws-cli:latest"
          command = ["sh", "-c", "cat $AWS_WEB_IDENTITY_TOKEN_FILE && echo && echo '-----' && aws sts get-caller-identity && sleep 60"]
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.trust.json

  tags = {
    Name = var.name
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "${var.issuer}:aud"
    }

    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:${kubernetes_namespace.this.metadata[0].name}:irsa-test"]
      variable = "${var.issuer}:sub"
    }
  }
}
