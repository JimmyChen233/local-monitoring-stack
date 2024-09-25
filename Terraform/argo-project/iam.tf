resource "aws_iam_role" "external_dns_role" {
  count = var.deploy_external_dns ? 1 : 0

  name = "ExternalDNSRole"

  assume_role_policy = local.assume_role_policy
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
  
  assume_role_policy = local.assume_role_policy
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

  assume_role_policy = local.assume_role_policy
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

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  count = var.deploy_aws_load_balancer_controller ? 1 : 0

  name = "aws-load-balancer-controller-eks-role"

  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
  count = var.deploy_aws_load_balancer_controller ? 1 : 0
  name        = "aws_load_balancer_controller-policy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = local.aws_lb_controller_policy


}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_policy_attachment" {
  count = var.deploy_aws_load_balancer_controller ? 1 : 0
  role       = aws_iam_role.aws_load_balancer_controller_role[0].name
  policy_arn = aws_iam_policy.aws_load_balancer_controller_policy[0].arn
}