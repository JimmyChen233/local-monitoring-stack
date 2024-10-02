locals {
  host                   = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_cluster.outputs.cluster_ca_certificate)
  oidc_provider          = replace(data.terraform_remote_state.eks_cluster.outputs.oidc_provider, "https://", "")
  account_id             = data.terraform_remote_state.eks_cluster.outputs.account_id

  assume_role_policy =  {
    for serviceaccountname, namespace in var.service_accounts : serviceaccountname => templatefile("${path.module}/files/assume_role_policy.json", {
      account_id     = local.account_id,
      oidc_provider  = local.oidc_provider,
      namespace      = namespace,
      serviceaccount = serviceaccountname,
    })
  }


  aws_lb_controller_policy = templatefile("${path.module}/files/aws_lb_controller_policy.json", {})

  kubectl_exec =  {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_cluster.outputs.cluster_name]
    env = {
      AWS_PROFILE = var.aws_profile
    }
  }
}
