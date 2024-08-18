resource "kubectl_manifest" "flux_system_namespace" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: flux-system
YAML
}

resource "github_repository" "flux-bootstrap-repo" {
    name        = var.github_repository
    description = var.github_repository
    visibility  = "private"
    auto_init   = true
    lifecycle {
    ignore_changes = [name]
    }
}

resource "flux_bootstrap_git" "default" {
    depends_on = [github_repository.flux-bootstrap-repo]

    embedded_manifests = true
    path               = "clusters/my-cluster"
}
