locals {
  host                   = data.terraform_remote_state.kind_cluster.outputs.endpoint
  cluster_ca_certificate = data.terraform_remote_state.kind_cluster.outputs.cluster_ca_certificate
  client_certificate     = data.terraform_remote_state.kind_cluster.outputs.client_certificate
  client_key             = data.terraform_remote_state.kind_cluster.outputs.client_key
}
