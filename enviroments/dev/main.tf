provider "aws" {
  region  = var.region["eu-west-1"]
  profile = var.profile
}

module "vpc" {
 source = "../modules/vpc"
 region                 = var.region["eu-west-1"]
  vpc_name               = var.vpc_name
  vpc_cidr_block         = var.vpc_cidr_block
  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks  = var.private_subnet_cidr_blocks
  availability_zone      = var.availability_zone["eu-west-1"]
}


resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zone["eu-west-1"])

  availability_zone = var.availability_zone["eu-west-1"][count.index]
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  vpc_id            = module.vpc.vpc_id

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.availability_zone["eu-west-1"])

  availability_zone = var.availability_zone["eu-west-1"][count.index]
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  vpc_id            = module.vpc.vpc_id

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnet[0].id 
}

module "instance" {
  source         = "../modules/aws_instance"
  region         = var.region["eu-west-1"]
  profile        = var.profile
  subnet_id      = aws_subnet.public_subnet[0].id 
  key_name       = var.key_name
  key_filename   = var.key_filename
  instance_ami   = var.ami
  vpc_id_id      = module.vpc.vpc_id
  security_name  = var.security_name
  instance_type  = var.instance_type

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
