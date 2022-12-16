resource "aws_lb_target_group" "target_group" {
  name     = var.name
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id



  health_check {
    enabled             = true
    interval            = "30"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "15"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200"

  }

target_type = "instance" 
}
