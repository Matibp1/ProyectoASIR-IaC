# Nombre del Proyecto

Una breve descripción sobre lo que hace tu proyecto y cuál es su propósito.

## Instalación

### Requisitos Previos
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [AWS cuenta ]
- [Visual Studio Code](#)

### Credenciales

Antes de empezar con todo si estas con una cuenta de estudiante y tiene el uso del IAM de AWS limitado haz los siguientes pasos

    - Localiza el direcotorio .aws Normalmente estara en esta ruta: C:\Users\NombreUsuario\.aws
    - Crea un fichero de texto si no esta llamado credential.txt
    - Copia el contenido del KEY, ACCESS y TOKEN que puedes encontrar cuando crear el laboratorio


### Pasos
1. Clona el repositorio en un directorio:
  
   - git clone https://github.com/Matibp1/ProyectoASIR

2. Navega al directorio del proyecto:

   - cd tu-repositorio

3. Crea proyecto de Terraform con estos pasos :
    
    -Abrir CMD o terminar de Visual
    -Terraform int
    -Terraform plan
    -Terraform apply

4. Destruir todo :
    
    -Terraform destroy

(Tanto para apply como destro existe la opcion -autoaprove por si estas seguro del plan y sabes que va tardar en ejecutarse)

## IMPORTANTE ⚠️

    ❗ EKS  (eks-cluster.tf)

    Crear un cluster lleva su tiempo, te recomiendo ir a prepararte un taza de cafe cuando le des a crear

## Usos Varios 🚀

    # Balanceador Web 
    El proyecto dispone de un balenceador propio para dos intancias se encarga de equilibrar el trafico de forma periodica entre las web

    # Balanceador Autoescalado

    Podemos hacer uso de uno de los EC2 fijos que hemos creado para ejecutar este pequeño script que simulara peticiones

    Para simular peticiones de clientes
    siege -c 10 -r 100 "DNS Balanceador"
        -c 10: Indica que se simularán 10 usuarios concurrentes.
        -r 100: Especifica que cada usuario simulado realizará 100 peticiones



