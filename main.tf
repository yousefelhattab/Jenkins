provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with the desired AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-EC2"
  }
}
