# Fichero para definir variables
# Amis aptas para la capa gratuita de AWS

variable "ami_Amazon_Linux" {
  type    = string
  default = "ami-051f8a213df8bc089" 
}
variable "ami_Windows_Server_2022" {
  type    = string
  default = "ami-09a2b3fd68bd8d01f" 
}
variable "ami_Debian_12" {
  type    = string
  default = "ami-058bd2d568351da34 " 
}
variable "ami_Ubuntu_Server" {
  type    = string
  default = "ami-080e1f13689e07408" 
}
#tipos de instancia
variable "tipo_t2micro" {
  type    = string
  default = "t2.micro" 
}
#llaves disponibles

variable "key_vockey" {
  type    = string
  default = "vockey" 
}

#zonas 
variable "zona_us_east_1" {
  type    = string
  default = "us-east-1"
}

variable "iam" {
  type = string
  default = "arn:aws:iam::609902961712:role/LabRole"
  
}