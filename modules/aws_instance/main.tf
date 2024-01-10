provider "aws" {
 region = "eu-west-2"
 profile = "default"
}

resource "aws_instance" "altcloud_instance" {
 ami           = "ami-0c55b159cbfafe1f0"
 instance_type = "t2.micro"
 subnet_id     = "subnet-055b159f4a2889a7b"
 key_name      = "altcloud_ssh"

 vpc_security_group_ids = [aws_security_group.sg-group.id]

 tags = {
    Name = "AltCloud Instance"
 }

 user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y software-properties-common python-apt-common
    sudo apt install -y ansible
    sudo apt install docker-ce
    sudo systemctl enable docker
    sudo systemctl status docker
    sudo apt-get install -y python3-pip
    sudo pip3 install boto
    ansible-playbook -i "localhost," -c local /Users/ansible/playbook.yml
 EOF
}


resource "aws_security_group" "sg-group" {
 name        = "allow_tcp"
 vpc_id      = "vpc-05ad99cbfa33cfa62"

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
