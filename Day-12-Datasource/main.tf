data "aws_security_group" "web-sg" {
    name = "default"
  
}

resource "aws_instance" "web" {
    ami = "ami-0332d564d76dbd8d6"
    instance_type = "t2.micro"
    vpc_security_group_ids = [data.aws_security_group.web-sg.id]
  
}