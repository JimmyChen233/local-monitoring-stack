data "terraform_remote_state" "kind_cluster" {
  backend = "local"
  config = {
    path = "../kind/terraform.tfstate"
  }
}