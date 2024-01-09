variable "region" {
 default = "eu-west-1"
}

variable "profile" {
 default = "default"
}

variable "environment" {
 default = "dev"
}

variable "ami" {
 default = "ami-09e67e426f25ce0d7"
}

variable "instance_type" {
 default = "t2.micro"
}

variable "key_name" {
 default = "altcloud_ssh"
}

variable "key_filename" {
 default = "/user/sibyl/.ssh/altcloud_ssh.pub"
}

variable "security_group" {
 default = "altcloud-sg"
}

variable "security_name" {
  description = "Name for the security group"
}
