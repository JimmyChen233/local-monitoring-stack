output "cluster_name" {
  value = aws_eks_cluster.demo.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}

output "node_role_arn" {
  value = aws_iam_role.demo.arn
}

output "oidc_provider" {
  value = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
