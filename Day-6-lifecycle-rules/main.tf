resource "aws_instance" "dev" {
  ami = "ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
    }


}

