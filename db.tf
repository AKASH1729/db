# Create a DB subnet group using 3 public subnets
resource "aws_db_subnet_group" "prod_subnet_group" {
  name       = "prod-db-subnet-group"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
    aws_subnet.subnet3-public.id
  ]

  tags = {
    Name = "Production DB Subnet Group"
  }
}

# Create the MySQL RDS instance using password from Secrets Manager
resource "aws_db_instance" "prod_db_instance" {
  identifier              = "proddb"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.41"
  instance_class          = "db.t3.medium"
  db_name                 = "prod_db"
  username                = "adminuser"
  password                = aws_secretsmanager_secret_version.secret_version.secret_string
  db_subnet_group_name    = aws_db_subnet_group.prod_subnet_group.name
  publicly_accessible     = true
  skip_final_snapshot     = true
}
