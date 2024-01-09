variable "ami" {
  description = "The AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "key_filename" {
  description = "The path to the public key file"
  type        = string
}

variable "security_group" {
  description = "The security group for the instance"
  type        = string
}

variable "environment" {
  description = "The environment for the instance"
  type        = string
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
}


