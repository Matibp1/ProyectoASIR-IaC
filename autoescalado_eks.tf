resource "aws_launch_template" "test1" {
  name_prefix   = "eks-launch-template"
  image_id      = var.ami_Amazon_Linux  
  instance_type = "t2.micro"   
  key_name  = var.key_vockey
  vpc_security_group_ids = [aws_security_group.grupo1.id, aws_security_group.grupo2.id]
  
}

resource "aws_autoscaling_group" "EC2autoescalado" {
  name                      = "Grupo2"
  launch_template {
    id                       = aws_launch_template.test1.id
    version                  = "$Latest"
  }
  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.miSubred.id, aws_subnet.miSubred2.id] 


  tag {
    key                 = "Name"
    value               = "EC2-autoescalable"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "escalado" {
  name                   = "escalado"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.EC2autoescalado.name
}

resource "aws_autoscaling_policy" "desescalado" {
  name                   = "desescalado"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.EC2autoescalado.name
}