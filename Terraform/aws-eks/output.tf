output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_role_arn" {
  value = aws_iam_role.main.arn
}

output "oidc_provider" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
