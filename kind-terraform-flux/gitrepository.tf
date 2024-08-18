resource "null_resource" "apply_git_repository" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/gitrepositories.yaml"
  }
  depends_on = [kind_cluster.default,flux_bootstrap_git.default]
}