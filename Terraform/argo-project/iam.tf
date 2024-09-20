resource "aws_iam_role" "external_dns_role" {
  count = var.deploy_external_dns ? 1 : 0

  name = "ExternalDNSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals" = {
            "${local.oidc_provider}:sub" = "system:serviceaccount:external-dns:external-dns"
          }
        }
      }
    ]
  })
}
