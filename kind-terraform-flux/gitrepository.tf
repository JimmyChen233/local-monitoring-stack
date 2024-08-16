resource "kubectl_manifest" "git_repositories" {
  for_each = fileset("${path.module}/repos", "*.yaml")
  yaml_body = file("${path.module}/repos/${each.value}")
}