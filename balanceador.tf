#Espacio para el balanceador de carga de la web

# Configuración del balanceador de carga
resource "aws_lb" "my_load_balancer" {
  name               = "mi-balanceador" #nombre 
  internal           = false
  load_balancer_type = "application" #tipo
  security_groups    = [aws_security_group.lb_sg.id]

  # Subnets donde estará disponible el balanceador, necesita un minimo de 2
  subnets = [ aws_subnet.miSubred.id, aws_subnet.miSubred2.id ]

  enable_deletion_protection = false #En produccion recomiendo cambiar esto

  tags = {
    Name = "mi-balanceador"
  }
}

# Definición del grupo de destino para el balanceador de carga
#Aqui asociaremos las instancias donde realizara el balanceo
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80   # Puerto del grupo de destino
  protocol = "HTTP"  # Protocolo del grupo de destino
  vpc_id   = aws_vpc.miRed.id # ID de la VPC

  # Configuración de la comprobación de salud
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399" 
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Configuracion del escuchador del balanceador de carga
# Aqui le indicamos donde tiene que escchar el balanceador, en nuestro caso es web
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = "80"  # Puerto del escuchador
  protocol          = "HTTP"  # Protocolo del escuchador

  default_action {
    type             = "forward" # Tipo de accion (reenviar)
    target_group_arn = aws_lb_target_group.my_target_group.arn #grupo de destino
  }
}

# Configuración de la conexión de las instancias EC2 al grupo de destino del balanceador de carga
# Asocioamos las dos instancias web a el target grup para que haga que cuanto llegue al balanceador reparta entre ellas
# ARN (Amazon Resource Name) es un identificador único para cada recurso
resource "aws_lb_target_group_attachment" "web_server1_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn # ARN del grupo
  target_id        = aws_instance.web_instance.id # ID de la instancia
  port             = 80
}
resource "aws_lb_target_group_attachment" "web_server2_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn # ARN del grupo
  target_id        = aws_instance.Instancia2.id # ID de la instancia
  port             = 80
}

# Configuración del grupo de seguridad para el balanceador de carga
# Nos aseguramos que el balanceador abra el puerto 80
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for load balancer"
  vpc_id      = aws_vpc.miRed.id

  # Permite el tráfico HTTP desde cualquier dirección
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
