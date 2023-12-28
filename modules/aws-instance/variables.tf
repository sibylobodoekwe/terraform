variable "ami" {
  description = "The AMI to use for the instance"
}

variable "instance_type" {
  description = "The type of EC2 instance"
}

variable "subnet_id" {
  description = "The ID of the subnet in which to launch the instance"
}

variable "key_name" {
  description = "The name of the EC2 key pair"
}