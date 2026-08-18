provider "aws" {
  
}

resource "aws_instance" "name" {
  ami = "ami-0332d564d76dbd8d6"
  instance_type = "t3.micro"
  count = length(var.ec2)
  tags = {
    Name = var.ec2[count.index]
  }
}

variable "ec2" {
    type = list(string)
    default = [ "ashok", "ashnika" ]
  
}