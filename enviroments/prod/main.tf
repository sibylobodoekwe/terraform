provider "aws" {
  region = "eu-west-1"
}

module "aws_instance_prod" {
  source     = "../modules/aws-instance"
  ami        = "ami-pqr"  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id  = "subnet-pqr"  # Specify your subnet ID
  key_name   = "prod-keypair"
}

module "ansible_prod" {
  source = "../modules/ansible"
}

module "docker_prod" {
  source = "../modules/docker"
}