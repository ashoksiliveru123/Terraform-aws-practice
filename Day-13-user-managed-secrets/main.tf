terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --------------------------------------------------
# Existing Secrets Manager Secret
# --------------------------------------------------

data "aws_secretsmanager_secret" "rds_secret" {
  name = "my-rds-credentials"
}

data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

# Decode the existing secret
locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.rds_secret_value.secret_string
  )
}

# --------------------------------------------------
# VPC
# --------------------------------------------------

resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-vpc"
  }
}

# --------------------------------------------------
# Private Subnet 1
# --------------------------------------------------

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "rds-private-subnet-1"
  }
}

# --------------------------------------------------
# Private Subnet 2
# --------------------------------------------------

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "rds-private-subnet-2"
  }
}

# --------------------------------------------------
# Security Group
# --------------------------------------------------

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.rds_vpc.id

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

# --------------------------------------------------
# DB Subnet Group
# --------------------------------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

# --------------------------------------------------
# RDS MySQL
# --------------------------------------------------

resource "aws_db_instance" "mysql" {
  identifier = "my-mysql-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name = "myapp"

  # Credentials come from Secrets Manager
  username = local.db_credentials.Username
  password = local.db_credentials.password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  storage_encrypted = true

  backup_retention_period = 7

  skip_final_snapshot = true

  tags = {
    Name        = "my-mysql-db"
    Environment = "dev"
  }
}

# --------------------------------------------------
# Outputs
# --------------------------------------------------

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_address" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}


