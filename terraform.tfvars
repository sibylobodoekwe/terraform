# terraform.dev.tfvars
region         = "eu-west-1"
profile        = "default"
environment    = "dev"
ami            = "ami-09e67e426f25ce0d7"
instance_type  = "t2.micro"
key_name       = "altcloud_ssh"
key_filename   = "/user/sibyl/.ssh/altcloud_ssh.pub"
security_group = "altcloud-sg"

# terraform.staging.tfvars
region         = "eu-west-1"
profile        = "default"
environment    = "staging"
ami            = "ami-09e67e426f25ce0d7"
instance_type  = "t2.micro"
key_name       = "altcloud_ssh"
key_filename   = "/user/sibyl/.ssh/altcloud_ssh.pub"
security_group = "altcloud-sg"
