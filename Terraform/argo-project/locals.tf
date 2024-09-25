locals {
  is_eks                 = var.cluster_type == "eks"
  host                   = !local.is_eks ? data.terraform_remote_state.kind_cluster[0].outputs.endpoint : data.terraform_remote_state.eks_cluster[0].outputs.cluster_endpoint
  cluster_ca_certificate = !local.is_eks ? data.terraform_remote_state.kind_cluster[0].outputs.cluster_ca_certificate : base64decode(data.terraform_remote_state.eks_cluster[0].outputs.cluster_ca_certificate)
  client_certificate     = !local.is_eks ? data.terraform_remote_state.kind_cluster[0].outputs.client_certificate : null
  client_key             = !local.is_eks ? data.terraform_remote_state.kind_cluster[0].outputs.client_key : null
  oidc_provider          = local.is_eks ? replace(data.terraform_remote_state.eks_cluster[0].outputs.oidc_provider, "https://", "") : null
  account_id             = local.is_eks ? data.terraform_remote_state.eks_cluster[0].outputs.account_id : null

  assume_role_policy = {
    for serviceaccountname, namespace in var.service_accounts : serviceaccountname => templatefile("${path.module}/files/assume_role_policy.json", {
      account_id     = local.account_id,
      oidc_provider  = local.oidc_provider,
      namespace      = namespace,
      serviceaccount = serviceaccountname,
    })
  }


  aws_lb_controller_policy = templatefile("${path.module}/files/aws_lb_controller_policy.json", {})

  kubectl_exec = local.is_eks ? {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_cluster[0].outputs.cluster_name]
    env = {
      AWS_PROFILE = var.aws_profile
    }
  } : null
}
