# Definir una instancia EC2 WEB
resource "aws_instance" "Instancia1" {
  ami                           = var.ami_Ubuntu_Server
  instance_type                 = var.tipo_t2micro
  key_name                      = var.key_vockey
  associate_public_ip_address   = true
  private_ip                    = "192.168.0.10"
  subnet_id                     = aws_subnet.miSubred.id 
  vpc_security_group_ids        = [aws_security_group.grupo1.id, aws_security_group.grupo2.id]
  
  user_data                     = file("/instalaciones/instalacion_apache.sh")
    
  tags                          = {
    Name = "Instancia1"
  }

}

