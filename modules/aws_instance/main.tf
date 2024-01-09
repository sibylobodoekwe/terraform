provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_instance" "altcloud_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  tags          = var.tags

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y software-properties-common python-apt-common
    sudo apt install -y ansible
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu jammy stable"
    sudo apt-cache policy docker-ce
    sudo apt install docker-ce
    sudo systemctl enable docker
    sudo systemctl status docker

    # Execute Ansible playbook
    sudo apt-get install -y python3-pip
    sudo pip3 install boto
    ansible-playbook -i "localhost," -c local /path/to/your/ansible/playbook.yml
  EOF
}

# Create a key pair
resource "aws_key_pair" "testkey" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create a private key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Put the private key in a local file
resource "local_file" "testkey_private" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = var.key_filename
}

# CREATE A SECURITY GROUP
resource "aws_security_group" "sg-group" {
  name        = var.security_name
  vpc_id      = var.vpc_id_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp"
  }
}
