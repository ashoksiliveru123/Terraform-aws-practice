#custom vpc creation
resource "aws_vpc" "custom_vpc"{
    cidr_block = var.vpc_cidr
    tags = {
        name = "custom_vpc-1"
    }
}
#custom subnets
resource "aws_subnet" "custom_subnet1"{
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = var.public_subnet-1_cidr
    tags = {
        name = "custom_public_subnet1"
    }
}
#custom internet gateway and attach to vpc
resource "aws_internet_gateway" "custom_igw"{
    vpc_id = aws_vpc.custom_vpc.id
    tags = {
        name = "custom_igw"
    }
}
#custom public route table and attach to vpc and route to internet gateway
resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.custom_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_igw.id
    }
    tags = {
        name = "public_route_table"
    }
}

#custom route table association with subnet
resource "aws_route_table_association" "custom_rta"{
    subnet_id = aws_subnet.custom_subnet1.id
    route_table_id = aws_route_table.public_route_table.id
}
#custom security group
resource "aws_security_group" "custom_sg"{
    name = "custom_sg"
    description = "custom security group"
    vpc_id = aws_vpc.custom_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}       

#custom ec2 instance creation
resource "aws_instance" "custom_ec2"{
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.custom_subnet1.id
    vpc_security_group_ids = [aws_security_group.custom_sg.id]
    tags = {
        name = "public_ec2_instance"
    }
}