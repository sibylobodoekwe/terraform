terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAT32PGRLUSYJMHVUK"
  secret_key = "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"
  profile    = "ssibs"
}