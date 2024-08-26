terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "0.4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}


provider "kind" {}

provider "helm" {
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = local.cluster_ca_certificate

    dynamic "exec" {
    for_each = local.is_eks ? [1] : []
    content {
      api_version = local.kubectl_exec.api_version
      command     = local.kubectl_exec.command
      args        = local.kubectl_exec.args
      env         = local.kubectl_exec.env
    }
  }
  }
}

provider "kubectl" {
  host                   = local.host
  cluster_ca_certificate = local.cluster_ca_certificate
  load_config_file       = false

  dynamic "exec" {
    for_each = local.is_eks ? [1] : []
    content {
      api_version = local.kubectl_exec.api_version
      command     = local.kubectl_exec.command
      args        = local.kubectl_exec.args
      env         = local.kubectl_exec.env
    }
  }
}
