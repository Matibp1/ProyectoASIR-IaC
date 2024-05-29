# Espacio para las EC2

#Dos instancias que crean una web nada mas levantarse, exactamente la misma para aplicar un balanceo
#Instancias para las WEB 1
resource "aws_instance" "web_instance" {
  ami                          = var.ami_Ubuntu_Server
  instance_type                = var.tipo_t2micro
  key_name                     = var.key_vockey
  associate_public_ip_address  = true
  private_ip                   = "192.168.0.50" # IP privada fija para la instancia
  subnet_id                    = aws_subnet.miSubred.id #ID de la subnet
  vpc_security_group_ids       = [aws_security_group.grupo1.id, aws_security_group.grupo2.id, aws_security_group.efs_sg.id] # IDs de los grupos de seguridad asociados

  user_data = file("/instalaciones/instalacion_apache.sh")  # Script de configuración inicial (instalación de Apache, la web, update etc)

  tags = {
    Name = "Instancia1"
  }
}
#Instancias para las WEB 2
resource "aws_instance" "Instancia2" {
  ami                           = var.ami_Ubuntu_Server
  instance_type                 = var.tipo_t2micro
  key_name                      = var.key_vockey
  associate_public_ip_address   = true
  private_ip                    = "192.168.0.51" # IP privada fija para la instancia
  subnet_id                     = aws_subnet.miSubred.id  #ID de la subnet
  vpc_security_group_ids       = [aws_security_group.grupo1.id, aws_security_group.grupo2.id, aws_security_group.efs_sg.id]
  
  user_data = file("/instalaciones/instalacion_apache2.sh")  # Script de configuración inicial (instalación de Apache, la web, update etc)
    
  tags                          = {
    Name = "Instancia2"
  }

}

#Instancias Variales

##Recomiendo dejar estas variables aqui por las EC2 de abajo dependen de ella, asi se puede llevar un mejor control
#Variable para establecer la cantidad de EC2 que se crearan con el codigo de abajo
variable "num_instances" {
  description = "Cantidad instancias"
  type        = number
  default     = 2 #valor
}
#variable para poder escalar el rango de IP de las EC2 pasadas por variables
variable "subnet_rango_ip" {
  description = "CIDR block de la subred"
  type        = string
  default     = "192.168.0.0/26"  
}
#Configuracion de la instancia que puede variar la cantidad
#Para modificar la cantidad de las intancias varia el valor de la variable "num_instances"
resource "aws_instance" "Instancia_variable" {
  count                        = var.num_instances  #variable de arriba
  ami                          = var.ami_Ubuntu_Server
  instance_type                = var.tipo_t2micro
  key_name                     = var.key_vockey
  associate_public_ip_address  = true
  private_ip                   = cidrhost(var.subnet_rango_ip, count.index + 20)  # Incrementa la IP en base al índice
  subnet_id                    = aws_subnet.miSubred.id
  vpc_security_group_ids       = [aws_security_group.grupo1.id, aws_security_group.grupo2.id]
  user_data                    = file("/instalaciones/instalacion_apache.sh")

  tags = {
    Name = "InstanciaVariable${count.index + 1}" # Etiqueta para la instancia con índice para añadir nombre
  }
}