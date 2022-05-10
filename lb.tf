resource "aws_lb" "option4" {
  name               = "option4-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.debug ? [aws_subnet.option4-pubnet[0].id] : [aws_subnet.option4-privnet[0].id]
}

resource "aws_lb_listener" "option4-listener" {
  load_balancer_arn = aws_lb.option4.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.option4-tg.arn
  }
}

resource "aws_lb_target_group" "option4-tg" {
  name     = "option4-tg"
  port     = 31555
  protocol = "HTTP"
  vpc_id   = aws_vpc.option4-vpc.id
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.option4-asg.id
  lb_target_group_arn    = aws_lb_target_group.option4-tg.arn
}
