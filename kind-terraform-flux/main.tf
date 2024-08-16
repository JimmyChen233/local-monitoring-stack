resource "kind_cluster" "this" {
  name            = "kind-flux"
  kubeconfig_path = local.k8s_config_path
  node_image      = "kindest/node:v1.25.0"
  wait_for_ready  = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
}

resource "github_repository" "this" {
  name        = var.github_repository
  description = var.github_repository
  visibility  = "private"
  auto_init   = true
  lifecycle {
    ignore_changes = [name]
    prevent_destroy = true
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}
