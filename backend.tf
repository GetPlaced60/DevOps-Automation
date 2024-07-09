terraform {
  backend "s3" {
    bucket = "terraform-tfstate-file-bucket"
    key = "ours/terraform.tfstate"
    region = "ap-south-1"
  }
}