terraform {
  backend "s3" {
    bucket         = "<your bucket here>"
    key            = "option4"
    dynamodb_table = "<your dynamodb table here>"
    profile        = "default"
    region         = "eu-central-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  required_version = "1.0.10"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
