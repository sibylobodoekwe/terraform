provider "aws" {
  region = "eu-west-1"
}

module "aws_instance_dev" {
  source     = "../modules/aws-instance"
  ami        = "ami-xyz"  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id  = "subnet-xyz"  # Specify your subnet ID
  key_name   = "dev-keypair"
}

module "ansible_dev" {
  source = "../modules/ansible"
}

module "docker_dev" {
  source = "../modules/docker"
}