resource " vpc" "altcloud_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "altdev-vpc"
  }
}

resource " subnet" "altcloud_public_subnet" {
  vpc_id                  =  vpc.altcloud_vpc.id
  cidr_block              = "10.24.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "altdev-pub"
  }
}

resource " internet_gateway" "altcloud_internet_gateway" {
  vpc_id =  vpc.altcloud_vpc.id

  tags = {
    Name = "altdev-igw"
  }
}

resource " route_table" "altcloud_public_rt" {
  vpc_id =  vpc.altcloud_vpc.id

  tags = {
    Name = "altdev-rt"
  }
}

resource " route" "default_route" {
  route_table_id         =  route_table.altcloud_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             =  internet_gateway.altcloud_internet_gateway.id
}

resource " route_table_association" "altcloud_public_assoc" {
  subnet_id      =  subnet.altcloud_public_subnet.id
  route_table_id =  route_table.altcloud_public_rt.id
}

resource " security_group" "altcloud_sg" {
  name        = "altdev-sg"
  description = "altdev security group"
  vpc_id      =  vpc.altcloud_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/20"] #change to for .md
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



#variables 


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIAT32PGRLUSYJMHVUK"
  secret_key = "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"
  profile    = "default"
}




terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}

module "instance_dev" {
  source         = "../modules/aws-instance"
  ami            = "ami-05d47d29a4c2d19e1"
  instance_type  = "t2.micro"
  subnet_id      = module.vpc.altcloud_public_subnet_id
  key_name       = "altcloud_ssh"
  key_filename   = "/home/user/.ssh/altcloud_ssh.pub"
  security_group = "altcloud-sg"
  environment    = "dev"
  tags = {
    Owner = "altcloud"
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  vpc_name           = "altcloud_vpc"
  cidr_block         = "10.0.0.0/16"
  subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b"]
}

resource "aws_subnet" "altcloud_public_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.24.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "altcloud_pub"
  }
}

resource "aws_subnet" "altcloud_private_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.24.2.0/24"  # Adjusted CIDR block for the private subnet
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "altcloud_priv"
  }
}


{
  "version": 4,
  "terraform_version": "1.6.4",
  "serial": 15,
  "lineage": "e22b3e61-9e3d-a5ee-f356-7d94e80a1f78",
  "outputs": {},
  "resources": [],
  "check_results": null
}
