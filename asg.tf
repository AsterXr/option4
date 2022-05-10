locals {
  subnets         = concat(aws_subnet.option4-privnet.*.id, aws_subnet.option4-pubnet.*.id)
  key_name        = var.debug ? "option4-key" : ""
  pub_cidr_block  = cidrsubnet(var.vpc_cidr, 2, 0)
  priv_cidr_block = cidrsubnet(var.vpc_cidr, 2, 1)
}

data "template_file" "user_data" {
  template = file("${path.root}/files/user_data.tpl")
}

resource "aws_launch_template" "option4" {
  name_prefix   = "option4"
  image_id      = "ami-09439f09c55136ecf"
  instance_type = "t3.micro"
  key_name      = local.key_name
  user_data     = base64encode(data.template_file.user_data.rendered)


  network_interfaces {
    associate_public_ip_address = var.debug
    security_groups             = [aws_security_group.option4-sg.id]
  }

  # dynamic "network_interfaces" {
  #   for_each = local.subnets
  #   content {
  #     device_index = network_interfaces.key
  #     # associate_public_ip_address = network_interfaces.key % 2 == 0 ? false : true
  #     #The associatePublicIPAddress parameter cannot be specified when launching with multiple network interfaces.
  #     associate_public_ip_address = var.debug
  #     private_ip_address = cidrhost(local.pub_cidr_block ,network_interfaces.key)
  #     security_groups = [aws_security_group.option4-sg.id]
  #     subnet_id = network_interfaces.value
  #   }
  # }
}

resource "aws_autoscaling_group" "option4-asg" {
  name                      = "option4-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  desired_capacity          = 2
  vpc_zone_identifier       = var.debug ? [aws_subnet.option4-pubnet[0].id] : [aws_subnet.option4-privnet[0].id]

  launch_template {
    id      = aws_launch_template.option4.id
    version = aws_launch_template.option4.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_schedule" "option4-startup" {
  autoscaling_group_name = aws_autoscaling_group.option4-asg.name
  scheduled_action_name  = "startup"
  min_size               = 1
  max_size               = 3
  desired_capacity       = 2
  recurrence             = "0 7 * * MON-FRI"
}

resource "aws_autoscaling_schedule" "option4-shutdown" {
  autoscaling_group_name = aws_autoscaling_group.option4-asg.name
  scheduled_action_name  = "shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 17 * * MON-FRI"
}

resource "aws_key_pair" "option4-instance-key" {
  count      = var.debug == true ? 1 : 0
  key_name   = local.key_name
  public_key = file("${path.module}/files/ssh.key")
}
