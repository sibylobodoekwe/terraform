
provider "aws" {
  region = "eu-west-1b"
}

module " instance_staging" {
  source     = "../modules/aws-instance"
  ami        = "ami-abc"  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id  = "subnet-abc"  # Specify your subnet ID
  key_name   = "staging-keypair"
}
