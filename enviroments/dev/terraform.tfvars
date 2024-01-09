region = {
  "eu-west-1" = "eu-west-1"
}
profile                     = "default"
vpc_name                    = "altcloud_vpc"
environment                 = "dev"
vpc_cidr_block              = "10.0.0.0/16"
public_subnet_cidr_blocks   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr_blocks  = ["10.0.3.0/24", "10.0.4.0/24"]
ami                         = "ami-0a1b36900d715a3ad"
instance_type               = "t2.micro"
key_name                    = "altcloud_ssh"
key_filename                = "/Users/sibyl/.ssh/altcloud_ssh.pub"
security_group              = "altcloud_sg"
security_name               = "altcloud_sec"
