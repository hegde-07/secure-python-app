terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  
}

resource "aws_s3_bucket" "static_assets" {
  bucket = "myapp-state-assets-12062025"

 tags = {
   name = "Static Assets"
 }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count = 1
  ami = "ami-02003f9f0fde924ea"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public1.id
  security_groups = [aws_security_group.web_sg.id]
  
  user_data = file("setup.sh")

  tags = {
    name = "AWS-Web"
  }
  }
