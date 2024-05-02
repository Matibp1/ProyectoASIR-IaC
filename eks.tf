resource "aws_eks_node_group" "nuevo_grupo_nodos" {
  cluster_name    = "mati-cluster"
  node_group_name = "Grupo1"
  node_role_arn   = "arn:aws:iam::609902961712:role/LabRole"
  subnet_ids      = [aws_subnet.miSubred.id, aws_subnet.miSubred2.id]

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  ami_type  = "AL2_x86_64"
  disk_size = 20

  remote_access {
  ec2_ssh_key = var.key_vockey
  source_security_group_ids = [aws_security_group.eks_grupo_seguridad.id]
}

  labels = {
    environment = "development"
  }

  tags = {
    Name = "eks-nodo-grupo1"
  }
}

#GRUPO DE SEGURIDAD

resource "aws_security_group" "eks_grupo_seguridad" {
  name        = "eks-grupo-seguridad"
  description = "Grupo seguridad para kubernetes"
  vpc_id      = aws_vpc.miRed.id

  # Regla de entrada tráfico dentro de la VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1  todos los protocolos
    cidr_blocks = [aws_vpc.miRed.cidr_block]
  }

  # Regla tráfico HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reglas de permitir trafico ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}