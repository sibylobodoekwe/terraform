provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source            = "/Users/sibyl/Documents/development/terraform/modules/vpc"
  region            = var.region
  vpc_name          = "altcloud_vpc"
  cidr_block        = "10.24.0.0/16"
  availability_zone = "eu-west-1a"

  vpc_tags = {
    Name        = "altcloud_vpc"
    Terraform   = "true"
    Environment = var.environment
  }
}

module "instance" {
  source          = "/Users/sibyl/Documents/development/terraform/modules/aws_instance"
  region          = var.region
  profile         = var.profile
  subnet_id       = module.vpc.altcloud_public_subnet_id
  key_name        = var.key_name
  key_filename    = var.key_filename
  instance_ami    = var.ami
  vpc_id_id       = module.vpc.vpc_id
  security_name   = var.security_name
  instance_type   = var.instance_type

  tags = {
    Terraform    = "true"
    Environment = var.environment
  }
}

resource "aws_subnet" "altcloud_public_subnet" {
  vpc_id                 = module.vpc.vpc_id
  cidr_block             = "10.24.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "altcloud_pub"
  }
}

resource "aws_subnet" "altcloud_private_subnet" {
  vpc_id                 = module.vpc.vpc_id
  cidr_block             = "10.24.2.0/24"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "altcloud_priv"
  }
}
