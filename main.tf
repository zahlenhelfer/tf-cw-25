terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0b2ac948e23c57071"
  instance_type = "t3.micro"

  tags = {
    Name       = "HelloWorld"
    Costcenter = "666"
  }
}
