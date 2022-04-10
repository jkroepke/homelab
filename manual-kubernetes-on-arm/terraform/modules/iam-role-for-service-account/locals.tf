locals {
  env = [{
    name  = "AWS_DEFAULT_REGION"
    value = data.aws_region.current.name
    }, {
    name  = "AWS_REGION"
    value = data.aws_region.current.name
    }, {
    name  = "AWS_ROLE_ARN"
    value = aws_iam_role.this.arn
    }, {
    name  = "AWS_WEB_IDENTITY_TOKEN_FILE"
    value = "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
    }, {
    name  = "AWS_STS_REGIONAL_ENDPOINTS"
    value = "regional"
  }]

  extraVolumeMounts = [
    {
      name      = "aws-iam-token"
      mountPath = "/var/run/secrets/eks.amazonaws.com/serviceaccount"
      readOnly  = true
    }
  ]

  extraVolumes = [
    {
      name = "aws-iam-token"
      projected = {
        sources = [
          {
            serviceAccountToken = {
              audience          = "sts.amazonaws.com"
              expirationSeconds = 86400
              path              = "token"
            }
          }
        ]
      }
    }
  ]
}
