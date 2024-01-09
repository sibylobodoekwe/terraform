variable "region" {
  description = "AWS region"
}

variable "profile" {
  description = "AWS profile"
}

variable "instance_ami" {
  description = "AMI for the instance"
}

variable "instance_type" {
  description = "Instance type"
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "key_name" {
  description = "Key name for the instance"
}

variable "tags" {
  description = "Tags for the instance"
  type        = map(string)
}

variable "key_filename" {
  description = "Path to the private key file"
}

variable "security_name" {
  description = "Name for the security group"
}

variable "vpc_id_id" {
  description = "ID of the VPC"
}
