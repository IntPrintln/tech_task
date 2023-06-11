provider "aws" {
  access_key = "..."
  secret_key = "..."
  region     = "us-east-1"
}

resource "aws_instance" "tech_task_ubuntu" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.Tech_task_SG.id]
  key_name = "key1"

tags = {
  Name = "Web server build by Terraform"
  Owner = "Admin1"
}
}

resource "aws_key_pair" "key1" {
  key_name   = "key1"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096 
}

resource "local_file" "key1" {
    content = tls_private_key.rsa.private_key_pem
    filename = "key1" 
}

resource "aws_security_group" "Tech_task_SG" {
  name        = "SG admins"
  description = "security Group tech task"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
tags = {
  Name = "Web server SecurityGroup"
  Owner = "Admin1"
  }
}
