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

provider "helm" {
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = local.cluster_ca_certificate
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    config_path            = local.k8s_config_path
  }
}

provider "kubectl" {
  host                   = local.host
  cluster_ca_certificate = local.cluster_ca_certificate
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  load_config_file       = true
  config_path            = local.k8s_config_path
}
