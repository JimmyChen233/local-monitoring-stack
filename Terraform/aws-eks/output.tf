output "cluster_name" {
  value = aws_eks_cluster.demo.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}

output "cluster_kubeconfig" {
  value = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = aws_eks_cluster.demo.name
    endpoint     = aws_eks_cluster.demo.endpoint
    cert_data    = aws_eks_cluster.demo.certificate_authority[0].data
  })
}
