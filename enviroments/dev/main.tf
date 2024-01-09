provider "aws" {
<<<<<<< HEAD
  region  = var.region
  profile = var.profile
}

module "instance" {
  source          = "/Users/sibyl/Documents/development/terraform/modules/aws_instance"
  environment     = var.environment
  subnet_id       = module.vpc.altcloud_public_subnet_id
  key_name        = var.key_name
  key_filename    = var.key_filename
  security_group  = var.security_group
  ami             = var.ami
  instance_type   = var.instance_type

  tags = {
    Terraform    = "true"
    Environment  = var.environment
  }
}

module "vpc" {
  source    = "/Users/sibyl/Documents/development/terraform/modules/vpc"
  region    = var.region

  vpc_tags = {
    Name        = "altcloud_vpc"
    Terraform   = "true"
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
=======
  region = "eu-west-1"
}

module "aws_instance_dev" {
  source     = "../modules/aws-instance"
  ami        = "ami-xyz"  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id  = "subnet-xyz"  # Specify your subnet ID
  key_name   = "dev-keypair"
}

module "ansible_dev" {
  source = "../modules/ansible"
}

module "docker_dev" {
  source = "../modules/docker"
}
>>>>>>> origin/main
