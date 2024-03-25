
terraform {
  required_providers {
    kind = {
        source = "tehcyx/kind"
        version = "0.4.0"
    }
    kubectl = {
        source = "gavinbunney/kubectl"
        version = ">= 1.7.0"
    }
  }
}

provider "kind" {}

provider "kubectl" {
  host = "${kind_cluster.default.endpoint}"
  cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
  client_certificate = "${kind_cluster.default.client_certificate}"
  client_key = "${kind_cluster.default.client_key}"
}

locals {
    k8s_config_path = pathexpand("./kind-kube-config.yaml")
}

resource "kind_cluster" "default" {
  name = "254-local-dev"
  kubeconfig_path = local.k8s_config_path
  node_image = "kindest/node:v1.23.4"
  wait_for_ready = true
  kind_config {
    kind = "Cluster"
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