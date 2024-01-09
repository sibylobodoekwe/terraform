variable "vpc_name" {
 description = "The name of the VPC"
 type        = string
}
variable "profile" {
 default = "default"
}
variable "cidr_block" {
 description = "The CIDR block for the VPC"
 type        = string
}

variable "availability_zone" {
 description = "The availability zone for the VPC"
 type        = string
}

variable "region" {
 description = "The AWS region for the VPC"
 type        = string
}

variable "vpc_tags" {
 description = "Tags to apply to the VPC"
 type        = map(string)
}