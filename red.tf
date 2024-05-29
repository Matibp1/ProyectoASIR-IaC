#Espacio para la red VPC (virtual private cloud)
# ESTO NO SE TOCA - ES LA RED  DEL PROYECTO - Cuidado al modificar

# Define la VPC
resource "aws_vpc" "miRed" {
  cidr_block           = "192.168.0.0/24"  # Bloque CIDR para la VPC
  enable_dns_support   = true  # Habilita soporte DNS en la VPC
  enable_dns_hostnames = true  # Habilita nombres de host DNS en la VPC

  tags = {
    Name = "miRed"  # Etiqueta para la VPC
  }
}

#  CIDR (Classless Inter-Domain Routing) es una notación utilizada para asignar 
#  y especificar direcciones IP y sus máscaras de red asociadas 

# Gateway
resource "aws_internet_gateway" "miPuerta" {
  vpc_id = aws_vpc.miRed.id  # ID de la VPC a la que se adjunta el Internet Gateway
}


# Subredes dentro de la VPC
# miSubred
resource "aws_subnet" "miSubred" {
  vpc_id            = aws_vpc.miRed.id # ID de la VPC a la que pertenece la subred
  cidr_block        = "192.168.0.0/26" # Bloque CIDR para la subred
  availability_zone = "us-east-1a" # Zona de disponibilidad 
  map_public_ip_on_launch = true # Asignar IPs públicas automáticamente a las instancias lanzadas en esta subred

  tags = {
    Name = "miSubred"
  }
}
# miSubred2
resource "aws_subnet" "miSubred2" {
  vpc_id            = aws_vpc.miRed.id # ID de la VPC a la que pertenece la subred
  cidr_block        = "192.168.0.64/26" # Bloque CIDR para la subred
  availability_zone = "us-east-1b" # Zona de disponibilidad, recomiento poner al menos zona a y b, algunos recursos piden dos zonas distintas
  map_public_ip_on_launch = true # Asignar IPs públicas automáticamente a las instancias lanzadas en esta subred

  tags = {
    Name = "miSubred2"
  }
}

# Asocia la subred al Internet Gateway mediante la tabla de rutas principal de la VPC
resource "aws_route_table_association" "miAsociacion" {
  subnet_id      = aws_subnet.miSubred.id # ID de la subred a asociar
  route_table_id = aws_vpc.miRed.main_route_table_id # ID de la tabla de rutas principal de la VPC, ver abajo
}
# Define una ruta en la tabla de rutas principal de la VPC
resource "aws_route" "miRuta" {
  route_table_id            = aws_vpc.miRed.main_route_table_id # ID de la tabla de rutas principal de la VPC
  destination_cidr_block    = "0.0.0.0/0"   # Bloque CIDR de destino (tráfico a cualquier lugar)
  gateway_id                = aws_internet_gateway.miPuerta.id # ID del Internet Gateway para enrutar el tráfico
}