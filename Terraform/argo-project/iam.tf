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
            "${local.oidc_provider}:sub" = "system:serviceaccount:externaldns:external-dns"
            "${local.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "external_dns_policy" {
  count = var.deploy_external_dns ? 1 : 0

  name = "ExternalDNSPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  count = var.deploy_external_dns ? 1 : 0

  role       = aws_iam_role.external_dns_role[0].name
  policy_arn = aws_iam_policy.external_dns_policy[0].arn
}

resource "aws_iam_role" "dprstestbucket_role" {
  count = var.deploy_dprs_poc ? 1 : 0
  name = "dprstestbucket-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action    = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:sub" = "system:serviceaccount:monitoring:s3-backup-sa"
            "${local.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dprstestbucket_policy" {
  count = var.deploy_dprs_poc ? 1 : 0
  name        = "dprstestbucket-policy"
  description = "Policy allowing the pod to upload files to S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::dprsbackuptest",
          "arn:aws:s3:::dprsbackuptest/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dprstestbucket_policy_attachment" {
  count = var.deploy_dprs_poc ? 1 : 0
  role       = aws_iam_role.dprstestbucket_role[0].name
  policy_arn = aws_iam_policy.dprstestbucket_policy[0].arn
}

resource "aws_iam_role" "cloudwatch_exporter_role" {
  count = var.deploy_cloudwatch_exporter ? 1 : 0

  name = "cloudwatch-exporter-eks-role"

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
            "${local.oidc_provider}:sub" = "system:serviceaccount:monitoring:cloudwatch-exporter-yet-another-cloudwatch-exporter"
            "${local.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_exporter_policy" {
  count = var.deploy_cloudwatch_exporter ? 1 : 0
  name        = "cloudwatch-exporter-policy"
  description = "Policy allowing cloudwatch exporter to fetch metrics from CloudWatch"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "iam:ListAccountAliases"
        ],
        Resource = [
          "*"
        ]
      },
      {
			  Effect    =  "Allow",
			  Action    = [
          "logs:GetLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
			  ],
			  Resource  = "arn:aws:logs:${var.region}:${local.account_id}:log-group:*"
		}
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_exporter_policy_attachment" {
  count = var.deploy_cloudwatch_exporter ? 1 : 0
  role       = aws_iam_role.cloudwatch_exporter_role[0].name
  policy_arn = aws_iam_policy.cloudwatch_exporter_policy[0].arn
}