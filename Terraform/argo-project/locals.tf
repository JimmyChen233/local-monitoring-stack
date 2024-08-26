locals {
  k8s_config_path          = var.kind_cluster == true ? "../kind/kind-kube-config.yaml" : "../aws-eks/eks-kube-config.yaml"
  host                     = var.kind_cluster == true ? data.terraform_remote_state.kind_cluster.outputs.endpoint : data.terraform_remote_state.eks_cluster[0].outputs.cluster_endpoint
  cluster_ca_certificate   = var.kind_cluster == true ? data.terraform_remote_state.kind_cluster.outputs.cluster_ca_certificate : base64decode(data.terraform_remote_state.eks_cluster[0].outputs.cluster_ca_certificate)
  client_certificate       = var.kind_cluster == true ? data.terraform_remote_state.kind_cluster.outputs.client_certificate : null
  client_key               = var.kind_cluster == true ? data.terraform_remote_state.kind_cluster.outputs.client_key : null
}