data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "obsstack-main-7"
    key    = "tfstate/terraform.tfstate"
    region = "ap-southeast-2"
  }
}