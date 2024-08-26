data "terraform_remote_state" "kind_cluster" {
  backend = "local"

  config = {
    path = "../kind/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_cluster" {
  count = var.kind_cluster == false ? 1 : 0
  backend = "local"
  config = {
    path = "../aws-eks/terraform.tfstate"
  }
}