resource "kind_cluster" "default" {
  name            = "254-local-dev"
  kubeconfig_path = local.k8s_config_path
  node_image      = "kindest/node:v1.23.4"
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
    node {
      role = "worker"
    }
  }
}
