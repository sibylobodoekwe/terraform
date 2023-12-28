Creating a modularized Terraform configuration for deploying AWS instances across multiple regions and availability zones, with the ability to customize for different environments and including scripts for Ansible and Docker, involves organizing your Terraform files and leveraging variables, modules, and scripts. Below is a simplified example to get you started:

Directory Structure:
plaintext
Copy code
terraform/
|-- environments/
|   |-- dev/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |-- staging/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |-- prod/
|   |   |-- main.tf
|   |   |-- variables.tf
|-- modules/
|   |-- aws-instance/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |-- ansible/
|   |   |-- main.yml
|   |-- docker/
|   |   |-- Dockerfile
Terraform Modules:
modules/aws-instance/main.tf

hcl
Copy code
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  // ... other instance settings
}
modules/aws-instance/variables.tf

hcl
Copy code
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
modules/ansible/main.yml

yaml
Copy code
# Ansible script for configuring instances
---
- name: Configure EC2 instances
  hosts: all
  tasks:
    # Your Ansible tasks here
modules/docker/Dockerfile

Dockerfile
Copy code
# Dockerfile for creating Docker container
# Your Dockerfile content here
Terraform Environments:
environments/dev/main.tf

hcl
Copy code
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
environments/staging/main.tf

hcl
Copy code
provider "aws" {
  region = "eu-central-1"
}

module "aws_instance_staging" {
  source     = "../modules/aws-instance"
  ami        = "ami-abc"  # Specify your AMI ID
  instance_type = "t2.micro"
  subnet_id  = "subnet-abc"  # Specify your subnet ID
  key_name   = "staging-keypair"
}

module "ansible_staging" {
  source = "../modules/ansible"
}

module "docker_staging" {
  source = "../modules/docker"
}
environments/prod/main.tf

hcl
Copy code
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
Notes:
Replace placeholder values (ami-xyz, subnet-xyz, etc.) with your actual values.
Define the appropriate variables in the Terraform modules to make them flexible.
The aws_instance module can be reused across environments by changing the input values.
Adjust the Ansible and Docker modules based on your specific requirements.
Make sure to secure your sensitive information using AWS Secrets Manager, Parameter Store, or another secure metho

terraform/environments/dev/main.tf
hcl
Copy code
provider "aws" {
  region     = "us-east-1"
}

module "aws_instance" {
  source = "../../modules/aws-instance"

  environment = "dev"
  availability_zones_count = var.availability_zones_count
}
This file sets up the AWS provider for the "dev" environment and includes the aws_instance module with the specified environment and availability zone count.

terraform/environments/dev/variables.tf
hcl
Copy code
variable "availability_zones_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}
This file defines the availability_zones_count variable to specify the number of availability zones for the "dev" environment.

terraform/environments/staging/main.tf
hcl
Copy code
provider "aws" {
  region     = "us-east-1"
}

module "aws_instance" {
  source = "../../modules/aws-instance"

  environment = "staging"
  availability_zones_count = var.availability_zones_count
}
Similar to the "dev" environment, this file sets up the AWS provider for the "staging" environment and includes the aws_instance module.

terraform/environments/staging/variables.tf
hcl
Copy code
variable "availability_zones_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}
This file defines the availability_zones_count variable for the "staging" environment.

terraform/environments/prod/main.tf
hcl
Copy code
provider "aws" {
  region     = "us-east-1"
}

module "aws_instance" {
  source = "../../modules/aws-instance"

  environment = "prod"
  availability_zones_count = var.availability_zones_count
}
Similar to the other environments, this file sets up the AWS provider for the "prod" environment and includes the aws_instance module.

terraform/environments/prod/variables.tf
hcl
Copy code
variable "availability_zones_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}
This file defines the availability_zones_count variable for the "prod" environment.

terraform/modules/aws-instance/main.tf
hcl
Copy code
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = var.availability_zones_count

  tags = {
    Name = "${var.environment}-instance-${count.index + 1}"
  }
}

output "instance_ids" {
  value = aws_instance.example[*].id
}
This file defines an AWS EC2 instance resource using the specified AMI and instance type. The count parameter ensures the creation of multiple instances based on the availability zone count. It also outputs the instance IDs.

terraform/modules/aws-instance/variables.tf
hcl
Copy code
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "availability_zones_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}
This file defines the environment variable and the availability_zones_count variable to customize the environment and availability zones for the AWS instance module.

terraform/modules/ansible/main.yml
yaml
Copy code
---
# Ansible playbook content goes here
This file is a placeholder for your Ansible playbook content. You can fill it with your specific configurations for provisioning and configuring instances.

terraform/modules/docker/Dockerfile
dockerfile
Copy code
# Dockerfile content goes here
This file is a placeholder for your Dockerfile content. You can customize it based on your specific Docker container requirements.

terraform/modules/vpc/main.tf
hcl
Copy code
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "altdev-vpc"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.24.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "altdev-pub"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "altdev-igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "altdev-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "altdev-sg"
  description = "altdev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
This file creates an AWS VPC with public subnet, internet gateway, route table, and security group. It establishes network configurations for instances.

README.md
markdown
Copy code
# Project README

This project uses Terraform to create an AWS instance in multiple regions.

## Directory Structure

- `terraform/`
  - `environments/`
    - `dev/`
      - `main.tf`
      - `variables.tf`
    - `staging/`
      - `main.tf`
      - `variables.tf`
    - `prod/`
      - `main.tf`
      - `variables.tf`
  - `modules/`
    - `aws-instance/`
      - `main.tf`
      - `variables.tf`
    - `ansible/`
      - `main.yml`
    - `docker/`
      - `Dockerfile`
    - `vpc/`
      - `main.tf`
      - `variables.tf`
  - `README.md 