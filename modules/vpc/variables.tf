variable "region" {
 type = map(string)
 default = {
    "eu-west-1" = "eu-west-1"
 }
}

variable "profile" {
 type = string
 default = "default"
}

variable "vpc_name" {
 type = string
 default = "altcloud_vpc"
}

variable "environment" {
 type = string
 default = "dev"
}

variable "vpc_cidr_block" {
 type = string
 default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
 type = list(string)
 default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
 type = list(string)
 default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ami" {
 type = string
 default = "ami-0a1b36900d715a3ad"
}

variable "instance_type" {
 type = string
 default = "t2.micro"
}

variable "key_name" {
 type = string
 default = "altcloud_ssh"
}

variable "key_filename" {
 type = string
 default = "/Users/sibyl/.ssh/altcloud_ssh.pub"
}

variable "security_group" {
 type = string
 default = "altcloud_sg"
}

variable "security_name" {
 type = string
 default = "altcloud_sec"
}

variable "availability_zone" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}