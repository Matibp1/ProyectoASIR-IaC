# Main.tf

# Proveedor de AWS
provider "aws" {
  region = "us-east-1" 
  shared_credentials_files = ["C:/Users/Mati/.aws/credentials.txt"]
}

# DEFINIR GRUPO DE SEGURIDAD 
# Grupo1 (HTTP)
resource "aws_security_group" "grupo1" {
  name        = "grupo1"
  description = "Grupo para permitir acceso HTTP"
  vpc_id      = aws_vpc.miRed.id  # IMPORTANTE Asociar el grupo de seguridad a la VPC miRed


  # Reglas de seguridad para tráfico HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Grupo2 (SSH)
resource "aws_security_group" "grupo2" {
  name        = "grupo2"
  description = "Grupo para permitir acceso SSH"
  vpc_id      = aws_vpc.miRed.id  # IMPORTANTE: Asociar el grupo de seguridad a la VPC miRed
  

  # Reglas de seguridad para tráfico SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




