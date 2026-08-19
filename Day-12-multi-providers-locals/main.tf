provider "aws" {
    region = "us-east-1"
  
}
provider "aws" {
  alias = "mumbai"
  region = "ap-south-1"
}

locals{
    instance_type="t2.micro"
}

resource "aws_instance" "default" {
  ami="ami-0332d564d76dbd8d6"
  instance_type= local.instance_type

}

resource "aws_instance" "mumbai" {
  provider = aws.mumbai
  ami = "ami-0ac7b260cf76d8865"
  instance_type=local.instance_type
}