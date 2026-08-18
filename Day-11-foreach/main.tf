provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-0332d564d76dbd8d6"
  instance_type = "t2.micro"
  for_each = toset(var.ec2)
  tags = {
    Name = each.value
  }
}

variable "ec2" {
    default = ["dev","prod"]
    type = list(string)
  
}