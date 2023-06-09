provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "Ubuntu"
  security_group = ["sg-056a48b30540e23da"]
}
