terraform {
  required_version = ">= 1.5"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = var.region
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "tf-vpc"
  cidr = "10.0.0.0/16"

  azs             = [for i in ["a", "b", "c"] : "${var.region}${i}"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_ipv6        = false

  tags = {
    Terraform   = "true"
    Environment = "demo"
  }
}

