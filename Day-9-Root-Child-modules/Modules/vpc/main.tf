resource "aws_vpc" "cust-vpc" {
cidr_block = var.vpc-cidrblock
  
}

resource "aws_subnet" "Cust-subnet" {
  vpc_id = aws_vpc.cust-vpc.id
  cidr_block = var.subnet_group
}