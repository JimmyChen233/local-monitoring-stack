resource "aws_iam_policy" "eks_assume_role_policy" {
  name        = "eks-assume-role-policy"
  description = "Policy to allow EKS nodes to assume roles"
  
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect"   : "Allow",
        "Action"   : "sts:AssumeRole",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_assume_role_policy_attachment" {
  role       = aws_iam_role.nodes.name
  policy_arn = aws_iam_policy.eks_assume_role_policy.arn
}