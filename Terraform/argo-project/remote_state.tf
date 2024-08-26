data "terraform_remote_state" "kind_cluster" {
  count   = var.cluster_type == "kind" ? 1 : 0
  backend = "local"

  config = {
    path = "../kind/terraform.tfstate"
  }
}

data "terraform_remote_state" "eks_cluster" {
  count   = var.cluster_type == "eks" ? 1 : 0
  backend = "s3"
  config = {
    bucket = "obsstack-demo"
    key    = "tfstate/terraform.tfstate"
    region = "ap-southeast-2"
  }
}