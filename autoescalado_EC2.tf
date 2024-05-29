#Espacio para crear un EC2 autoecalable
#La idea de esto es crear un EC2 que cuando reciba un minimo de peticiones se autoescale el solo, creando copiar de si mismo

# Plantilla de lanzamiento
# Se basara en esto para lanzarlo
resource "aws_launch_template" "autoescalable" {
  name_prefix   = "autoescalable"
  image_id      = var.ami_Amazon_Linux   # ID de la AMI para instancias
  instance_type = "t2.micro"    # Tipo de instancia
  key_name      = var.key_vockey
  vpc_security_group_ids = [aws_security_group.grupo1.id, aws_security_group.grupo2.id]  # ID de Grupos de seguridad
}

# Grupo de Autoescalado
# Esto se encarga de agrupar las instancias autoescalables
resource "aws_autoscaling_group" "EC2autoescalado" {
  name                      = "Grupo2"
  launch_template {
    id                       = aws_launch_template.autoescalable.id # ID de la plantilla de lanzamiento
    version                  = "$Latest" # Última versión de la plantilla
  }
  min_size                  = 1 # Número mínimo de instancias
  max_size                  = 3 # Número máximo de instancias
  desired_capacity          = 1 # Número deseado de instancias, empezamos con 1 y podemos llegar a 3
  vpc_zone_identifier       = [aws_subnet.miSubred.id, aws_subnet.miSubred2.id]

  tag {
    key                 = "Name"
    value               = "EC2-autoescalable"
    propagate_at_launch = true
  }
}
#Politicas para realizar el auto escalado, esto se aplicara cuando lleguen las condicioens
# Política de escalado
resource "aws_autoscaling_policy" "escalado" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling" # Tipo de política
  scaling_adjustment     = 1 # Ajuste de desescalado, suma una instancia
  cooldown               = 30 # Periodo de enfriamiento
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.EC2autoescalado.name # Nombre del grupo de autoescalado, arriba
}
# Política de desescalado
resource "aws_autoscaling_policy" "desescalado" {
  name                   = "scale_down"
  policy_type            = "SimpleScaling" # Tipo de política
  scaling_adjustment     = -1 # Ajuste de desescalado, resta una instancia
  cooldown               = 300 # Periodo de enfriamiento
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.EC2autoescalado.name # Nombre del grupo de autoescalado, arriba
}
# Balanceador de carga
# Creamos otro balanceado de carga que es a donde haremos las peticiones entrantes por el puerto 80
resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grupo1.id] # Grupos de seguridad http, definifo en main.tf
  subnets            = [aws_subnet.miSubred.id, aws_subnet.miSubred2.id]  # ID Subredes
}
# Grupo de destino del balanceador de carga
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.miRed.id # ID de la VPC
  target_type = "instance"
}
# Configuración del listener del balanceador de carga, el puesto que va escuchar el balanceador
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn  # ARN del balanceador de carga
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward" #Reencia las peticiones al grupo destino del balanceador de carga
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
# Asociación de autoescalado y grupo de destino
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.EC2autoescalado.name # Nombre del grupo de autoescalado
  lb_target_group_arn    = aws_lb_target_group.target_group.arn # ARN del grupo de destino
}

# Alarma de CloudWatch para contar solicitudes altas
resource "aws_cloudwatch_metric_alarm" "high_request_count" {
  alarm_name          = "high_request_count" #nombre
  comparison_operator = "GreaterThanOrEqualToThreshold" # Operador de comparación, compara con el umbral
  evaluation_periods  = "1"
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum" # Estadística
  threshold           = "100" # Umbral de peticiones

  dimensions = {
    TargetGroup  = aws_lb_target_group.target_group.arn_suffix
    LoadBalancer = aws_lb.load_balancer.arn_suffix
  }
  
 #La alamar dispara las alarmas
  alarm_actions       = [aws_autoscaling_policy.escalado.arn] # Acciones al activar alarma
  ok_actions          = [aws_autoscaling_policy.desescalado.arn]  # Acciones al restablecer alarma
}
