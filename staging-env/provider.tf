provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.55"
    }
  }
  #backend "s3" {
  #  bucket  = "terraform-network-hello-world"
  #  key     = "terraform-network/us-west-2/main.tfstate"
  #  region  = "us-west-2"
  #  encrypt = true
  #}
  required_version = "~> 0.14.11"
}