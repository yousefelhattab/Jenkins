terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Define the variable for the instance name
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  # Use the instance_name variable passed from the Jenkins pipeline
  name = var.instance_name

  instance_type          = "t2.micro"
  key_name               = "ansible"
  
  vpc_security_group_ids = ["sg-0eb11d9a0361848f3"]
  subnet_id              = "subnet-02e7e46a9acf6627b"
  

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

