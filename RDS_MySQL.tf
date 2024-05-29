#Espacio para RDS (Relational Database Service)  Bases de datos

# Instancia de RDS MySQL
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20 #Tamaño en GB
  storage_type         = "gp2" #tipo almacenamiento
  engine               = "mysql" #Motor base de datos
  engine_version       = "8.0" # Version del motor
  instance_class       = "db.t3.micro" #Tipo instancia base de datos
  identifier           = "mydatabase"  #Identificador unico para la instancia de base de datos
  username             = "admin"   #Usuario admin
  password             = "leviosaaa123"  #Contraseña (recomiendo no pasarla asi, buscar de mejor seguridad)
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # ID del grupo de seguridad de RDS
  db_subnet_group_name   = aws_db_subnet_group.default.name # Nombre del grupo de subredes de la base de datos

  # Backup y mantenimiento
  backup_retention_period = 7  # Periodo de retención de backups en días
  backup_window           = "01:00-04:00"  # Ventana de tiempo para realizar backups (las copias siempre de madrugada)
  maintenance_window      = "Sun:05:00-Sun:06:00"  # Ventana de tiempo para realizar mantenimiento
}

# Grupo de Subredes de la Base de Datos
# Asi agrupamos las subredes donde estara la base de datos, es otra manera de enfocarlo, en otros ficheros le paso directemente 
# el id de las subredes al recurso
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = [ aws_subnet.miSubred.id, aws_subnet.miSubred2.id ] # IDs de las subredes incluidas en el grupo

  tags = {
    Name = "rds-subnet-group"
  }
}

# Grupo de Seguridad para RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.miRed.id # ID de la VPC a la que pertenece
   # Reglas de entrada para el grupo de segurida
  ingress {
    from_port   = 3306 # Puerto de inicio (3306 para MySQL)
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfico desde cualquier dirección IP
  }
  # Reglas de salida para el grupo de seguridad
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 indica todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfico a cualquier dirección IP
  }

  tags = {
    Name = "rds-security-group"
  }
}
