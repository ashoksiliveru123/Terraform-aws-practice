resource "aws_db_instance" "this" {
  identifier        = var.identifier
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name = aws_db_subnet_group.default.name

  

  publicly_accessible = false
  multi_az            = var.multi_az

  skip_final_snapshot = true
}