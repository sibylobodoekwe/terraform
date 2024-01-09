provider "aws" {
 region = var.region
 profile = var.profile
}

resource "aws_vpc" "altcloud_vpc" {
 cidr_block           = var.cidr_block
 enable_dns_support   = true
 enable_dns_hostnames = true
}

resource "aws_subnet" "altcloud_public_subnet" {
 vpc_id                 = aws_vpc.altcloud_vpc.id
 cidr_block              = "10.0.1.0/24"
 map_public_ip_on_launch = true
 availability_zone       = var.availability_zone
}

resource "aws_subnet" "altcloud_private_subnet" {
 vpc_id          = aws_vpc.altcloud_vpc.id
 cidr_block      = "10.0.2.0/24"
 availability_zone = var.availability_zone
}