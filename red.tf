# ESTO NO SE TOCA - ES LA RED  DEL PROYECTO
# Define la VPC
resource "aws_vpc" "miRed" {
  cidr_block           = "192.168.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "miRed"
  }
}

# Gateway
resource "aws_internet_gateway" "miPuerta" {
  vpc_id = aws_vpc.miRed.id  
}


# Subredes dentro de la VPC
resource "aws_subnet" "miSubred" {
  vpc_id            = aws_vpc.miRed.id
  cidr_block        = "192.168.0.0/26" 
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "miSubred"
  }
}

resource "aws_subnet" "miSubred2" {
  vpc_id            = aws_vpc.miRed.id
  cidr_block        = "192.168.0.64/26"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "miSubred2"
  }
}

# Asociar red a puerta de enlace
resource "aws_route_table_association" "miAsociacion" {
  subnet_id      = aws_subnet.miSubred.id
  route_table_id = aws_vpc.miRed.main_route_table_id
}

# Enrutamiento
resource "aws_route" "miRuta" {
  route_table_id            = aws_vpc.miRed.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"  
  gateway_id                = aws_internet_gateway.miPuerta.id
}