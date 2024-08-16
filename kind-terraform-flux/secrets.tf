resource "kubernetes_secret" "git_credentials" {
  metadata {
    name      = "gitcredentials"
    namespace = "flux-system"
  }

  data = {
    github_token    = base64encode(var.github_token)
    github_org      = base64encode(var.github_org)
    github_repository = base64encode(var.github_repository)
  }
  depends_on = [kind_cluster.this,]
}