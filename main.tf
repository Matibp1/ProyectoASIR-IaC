# Main.tf

# Proveedor de AWS
provider "aws" {
  region                   = "us-east-1"  #region
  shared_credentials_files = ["C:/Users/Mati/.aws/credentials.txt"] # Ruta al archivo de credenciales de AWS
}

# DEFINIR GRUPO DE SEGURIDAD 
# Grupo1 (HTTP)
resource "aws_security_group" "grupo1" {
  name        = "grupo1"
  description = "Grupo para permitir acceso HTTP"
  vpc_id      = aws_vpc.miRed.id  # IMPORTANTE Asociar el grupo de seguridad a la VPC miRed


  # Reglas de seguridad para tráfico HTTP entrenate 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Reglas de seguridad para tráfico HTTP saliente 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir cualquier IP
  }
}

# Grupo2 (SSH)
resource "aws_security_group" "grupo2" {
  name        = "grupo2"
  description = "Grupo para permitir acceso SSH"
  vpc_id      = aws_vpc.miRed.id  # IMPORTANTE: Asociar el grupo de seguridad a la VPC miRed
  

  # Reglas de seguridad para tráfico SSH entrenate 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir cualquier IP
  }
  # Reglas de seguridad para tráfico SSH saliente 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permitir todo tipo de tráfico
    cidr_blocks = ["0.0.0.0/0"]  # Permitir cualquier IP
  }
}




