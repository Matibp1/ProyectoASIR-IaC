#Espacio para crear nodos de EKS EKS (Elastic Kubernetes Service)
#Los nodos son  máquinas virtuales que ejecuta aplicaciones en un clúster de Kubernetes administrado por AWS.

# Definición del grupo de nodos para el clúster EKS
resource "aws_eks_node_group" "nuevo_grupo_nodos" {
  cluster_name    = "mati-cluster" #Nombre del cluster donde se crea
  node_group_name = "Grupo1" # Nombre del grupo de nodos
  node_role_arn   = "arn:aws:iam::425164705412:role/LabRole"
  subnet_ids      = [aws_subnet.miSubred.id, aws_subnet.miSubred2.id]
  depends_on = [aws_eks_cluster.mati-cluster] #Espera a que este creado el cluster para evitar errores
  scaling_config {
    min_size     = 1 # tamaño minimo del grupo de nodos
    max_size     = 3 # tamaño maximo del grupo de nodos
    desired_size = 2 # tamaño deseado del grupo de nodos (cuando se crea)
  }

  ami_type  = "AL2_x86_64" # Tipo de AMI para los nodos
  disk_size = 20  # Tamaño del disco en GB para cada nod

  remote_access {
  ec2_ssh_key = var.key_vockey  
  source_security_group_ids = [aws_security_group.eks_grupo_seguridad.id] # ID del grupo de seguridad propio para eks, ver abajo
}

  labels = {
    environment = "development"
  }

  tags = {
    Name = "eks-nodo-grupo1"
  }
}

#GRUPO DE SEGURIDAD eks
# Definición del grupo de seguridad para los nodos EKS
resource "aws_security_group" "eks_grupo_seguridad" {
  name        = "eks-grupo-seguridad"
  description = "Grupo seguridad para kubernetes"
  vpc_id      = aws_vpc.miRed.id  #ID de la VPC que pertenece

  # Regla de entrada tráfico dentro de la VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1  todos los protocolos
    cidr_blocks = [aws_vpc.miRed.cidr_block] # Permitir tráfico desde toda la VPC
  }
  #Metemos las dos reglas mas basicas que son las http por si hacemos una web y ssh para las conecxiones
  #Si montamos una app dentro de los nodos tocara abrir los puestos necesario agrandando esto
 
  # Regla tráfico HTTP entrada
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfico desde cualquier dirección IP
  }

  # Reglas de permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de permitir trafico ssh entrada
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}