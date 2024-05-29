# Espacio para crear cluster de EKS (Elastic Kubernetes Service)

#Cluster de EKS
#Recomendacion: con cuenta de estudiante los permisos son muy limtados, si amplias mucho la configuracion del cluster te van a sarli errores
#Si tienes control para crear permisos IAM tienes mas margen de maniobra, por eos este apartado esta sencillo
resource "aws_eks_cluster" "mati-cluster" {
  name     = "mati-cluster"  #nombre
  role_arn = var.iam         #

  vpc_config {
    subnet_ids = [ aws_subnet.miSubred.id,  aws_subnet.miSubred2.id ] # ID de las Subnets, tiene que ter un minimo de dos
  }

}
