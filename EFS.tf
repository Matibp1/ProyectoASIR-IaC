#Espacio para EFS (Elastic File System)

#Recurso EFS
resource "aws_efs_file_system" "mi_efs" {
  creation_token      = "mi-efs-proyecto-mati"  # Nombre unico para identificar el sistema de archivos de EFS
  performance_mode    = "generalPurpose"  # Modo de rendimiento
  throughput_mode     = "bursting"  # Modo de rendimiento
  lifecycle_policy {
    transition_to_ia  = "AFTER_30_DAYS"  # Mueve los archivos a Infrequent Access despues de 30 días de inactividad
  }
}


# Punto de montaje de EFS
resource "aws_efs_mount_target" "mi_efs_mount" {
  file_system_id  = aws_efs_file_system.mi_efs.id # ID del sistema de archivos EFS
  subnet_id       = aws_subnet.miSubred.id  # ID de la subred donde se creara el punto de montaje
  security_groups = [aws_security_group.efs_sg.id] # IDs de los grupos de seguridad 
}


#grupo especifico para efs
#como se trata de un recurso espeficico vamos a dejar el grupo de seguridad junto al recurso para control facilemte el puerto
resource "aws_security_group" "efs_sg" {
  name_prefix  = "efs_sg"
   vpc_id      = aws_vpc.miRed.id

  # Reglas de seguridad para tráfico entrante
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir cualquier IP
  }
  # Reglas de seguridad para tráfico saliente 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permitir todo tipo de tráfico
    cidr_blocks = ["0.0.0.0/0"] # Permitir cualquier IP
  }
}

