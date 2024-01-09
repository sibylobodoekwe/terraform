provider "aws" {
  region  = var.region["eu-west-1"]
  profile = var.profile
}

resource "aws_vpc" "altcloud_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "altcloud_public_subnet" {
  vpc_id                 = aws_vpc.altcloud_vpc.id
  cidr_block             = var.public_subnet_cidr_blocks[0] 
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone[0] 
}

resource "aws_subnet" "altcloud_private_subnet" {
  vpc_id          = aws_vpc.altcloud_vpc.id
  cidr_block      = var.private_subnet_cidr_blocks[0]  
  availability_zone = var.availability_zone[1]  
}
