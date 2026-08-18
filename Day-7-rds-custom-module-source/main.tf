module "rds" {
  source = "./rds"

  identifier              = "database-1"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "myapp"
  username                = "admin"
  password                = "admin123"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  multi_az                = false
}