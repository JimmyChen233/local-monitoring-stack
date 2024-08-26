terraform {
  backend "s3" {
    bucket         = "obsstack-demo"
    key            = "tfstate/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true   
  }
}