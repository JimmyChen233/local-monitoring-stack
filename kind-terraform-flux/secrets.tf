resource "kubectl_manifest" "git_credentials" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: gitcredentials
  namespace: flux-system
type: Opaque
data:
  github_token: ${base64encode(var.github_token)}
  github_org: ${base64encode(var.github_org)}
  github_repository: ${base64encode(var.github_repository)}
YAML

  depends_on = [kind_cluster.default,kubectl_manifest.flux_system_namespace]
}