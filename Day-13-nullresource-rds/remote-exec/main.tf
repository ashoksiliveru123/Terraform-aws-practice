terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-vpc"
  }
}

# -------------------------
# Private Subnet 1
# -------------------------

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "rds-private-subnet-1"
  }
}

# -------------------------
# Private Subnet 2
# -------------------------

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  

  tags = {
    Name = "rds-private-subnet-2"
  }
}

# -------------------------
# Security Group
# -------------------------

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id
  

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# -------------------------
# DB Subnet Group
# -------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "my-rds-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "my-rds-subnet-group"
  }
}
# mysql server
resource "aws_instance" "mysql_client" {
  ami = "ami-0332d564d76dbd8d6"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  subnet_id = aws_subnet.private_1.id
  user_data = file("userdata")

  tags = {
    Name = "mysql-client"
  }
}

#mysql client server sg
resource "aws_security_group" "mysql-sg" {
  name = "mysql-sg"
  vpc_id = aws_vpc.main.id

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

# -------------------------
# RDS MySQL
# -------------------------

resource "aws_db_instance" "mysql" {
  identifier = "my-mysql-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "myapp"
  username = "admin"

  # AWS RDS generates and manages
  # the master password in Secrets Manager
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  backup_retention_period = 7

  skip_final_snapshot = true

  tags = {
    Name        = "my-mysql-db"
    Environment = "dev"
  }
}

# nullresource

resource "null_resource" "mysql_setup" {

  connection {
    type        = "ssh"
    host        = aws_instance.mysql_client.public_ip
    user        = "ec2-user"
    private_key = file("my-key.pem")
  }

  provisioner "file" {
    source      = "test.sql"
    destination = "/tmp/test.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "mysql -h ${aws_db_instance.mysql.address} -u admin -p admin123 myapp < /tmp/test.sql"
    ]
  }

  depends_on = [
    aws_db_instance.mysql,
    aws_instance.mysql_client
  ]
}
# -------------------------
# Outputs
# -------------------------

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "rds_secret_arn" {
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}