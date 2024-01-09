Creating a modularized Terraform configuration for deploying AWS instances across multiple regions and availability zones, with the ability to customize for different environments and including scripts for Ansible and Docker, involves organizing your Terraform files and leveraging variables, modules, and scripts. Below is a simplified example to get you started:

Directory Structure:
plaintext
Copy code
terraform/
|-- environments/
|   |-- dev/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- versions.tf
|   |-- staging/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- versions.tf
|   |-- terraform.tfvars
|-- modules/
|   |-- aws-instance/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |-- vpc/
|   | |-- main.tf
|   | |-- variables.tf
|   | |-- outputs.tf
|-- README.md

Terraform Modules:
modules/aws-instance/main.tf

hcl
Copy code
resource " instance" "example" {
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

module " instance_dev" {
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

module " instance_staging" {
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

module " instance_prod" {
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
The  instance module can be reused across environments by changing the input values.
Adjust the Ansible and Docker modules based on your specific requirements.
Make sure to secure your sensitive information using AWS Secrets Manager, Parameter Store, or another secure metho

terraform/environments/dev/main.tf
hcl
Copy code
provider "aws" {
  region     = "us-east-1"
}

module " instance" {
  source = "../../modules/aws-instance"

  environment = "dev"
  availability_zones_count = var.availability_zones_count
}
This file sets up the AWS provider for the "dev" environment and includes the  instance module with the specified environment and availability zone count.

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

module " instance" {
  source = "../../modules/aws-instance"

  environment = "staging"
  availability_zones_count = var.availability_zones_count
}
Similar to the "dev" environment, this file sets up the AWS provider for the "staging" environment and includes the  instance module.

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

module " instance" {
  source = "../../modules/aws-instance"

  environment = "prod"
  availability_zones_count = var.availability_zones_count
}
Similar to the other environments, this file sets up the AWS provider for the "prod" environment and includes the  instance module.

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
resource " instance" "example" {
  ami           = "ami-0 c55 b159 cbfafe1 f0"
  instance_type = "t2.micro"
  count         = var.availability_zones_count

  tags = {
    Name = "${var.environment}-instance-${count.index + 1}"
  }
}

output "instance_ids" {
  value =  instance.example[*].id
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
resource " vpc" "altcloud_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "altdev-vpc"
  }
}

resource " subnet" "altcloud_public_subnet" {
  vpc_id                  =  vpc.altcloud_vpc.id
  cidr_block              = "10.24.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1 a"

  tags = {
    Name = "altdev-pub"
  }
}

resource " internet_gateway" "altcloud_internet_gateway" {
  vpc_id =  vpc.altcloud_vpc.id

  tags = {
    Name = "altdev-igw"
  }
}

resource " route_table" "altcloud_public_rt" {
  vpc_id =  vpc.altcloud_vpc.id

  tags = {
    Name = "altdev-rt"
  }
}

resource " route" "default_route" {
  route_table_id         =  route_table.altcloud_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             =  internet_gateway.altcloud_internet_gateway.id
}

resource " route_table_association" "altcloud_public_assoc" {
  subnet_id      =  subnet.altcloud_public_subnet.id
  route_table_id =  route_table.altcloud_public_rt.id
}

resource " security_group" "altcloud_sg" {
  name        = "altdev-sg"
  description = "altdev security group"
  vpc_id      =  vpc.altcloud_vpc.id

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


  Here is one way to create reusable Terraform code to provision EC2 instances across multiple regions and availability zones:

First, create a modules directory to hold your reusable infrastructure code:


Insert at cursor

Copy
mkdir modules
In 
modules/ec2-instance/main.tf
:

hcl

Insert at cursor

Copy
resource " instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]

  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}
This defines the core  instance resource, making the AMI, instance type, subnet, security group etc variables.

In 
modules/ec2-instance/variables.tf
:

hcl

Insert at cursor

Copy
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {} 
variable "security_group_id" {}
variable "key_name" {}
variable "instance_name" {}
Now in your environments directory (e.g. 
environments/dev/main.tf
), you can call this module:

hcl

Insert at cursor

Copy
module "ec2_instance_euwest1" {
  source = "../modules/ec2-instance"

  ami           = "ami-abcd1234" 
  instance_type = "t2.micro"

  subnet_id = "subnet-1234abcd"
  # etc

  instance_name = "webserver-euwest1"
}

module "ec2_instance_eucen1" {
  source = "../modules/ec2-instance"

  ami           = "ami-dcba4321"
  instance_type = "t2.micro" 

  subnet_id = "subnet-dcba4321"
  # etc

  instance_name = "webserver-eucen1" 
}
This allows you to provision the same instance across regions/AZs easily and