variable "region" {
  type    = map(string)
  default = {
    "eu-west-1" = "eu-west-1"
  }
}

variable "profile" {
  default = "default"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ami" {
  default = "ami-0a1b36900d715a3ad"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "altcloud_ssh"
}

variable "key_filename" {
  default = "/Users/sibyl/.ssh/altcloud_ssh.pub"
}

variable "security_group" {
  default = "altcloud_sg"
}

variable "security_name" {
  description = "Name for the security group"
}

variable "availability_zone" {
  type        = map(list(string))
  description = "Map of lists of availability zones for subnets"
  default     = {
    "eu-west-1" = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  }
}
