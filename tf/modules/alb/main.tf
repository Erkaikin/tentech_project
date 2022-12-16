# create alb

/*resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets           = var.subnet_id


}

# Adding listeners to alb
/*
resource "aws_lb_listener" "http_listener" {
load_balancer_arn =  aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [
    aws_lb_listener.https-listener
  ]
  
}
/*
#data call for certificate
data "aws_acm_certificate" "issued" {
  domain =  "erkai-tentech.com"
  statuses = ["ISSUED"]
}

*/

# Adding https port 443
/*
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy = "ELBSecurityPolicy-2016-08"
  #certificate_arn = data.aws_acm_certificate.issued.arn

  default_action {
    type = "forward"
    target_group_arn = var.my_target_group_arn
  }
  depends_on = [
aws_lb.alb
 ]
}
*/


resource "aws_lb" "lb" {
  name                             = var.name
  load_balancer_type               = var.load_balancer_type
  internal                         = var.internal
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type


  access_logs {
    bucket  = var.bucket
    enabled = var.enabled
  }

  timeouts {
    create = var.lb_create_timeout
    update = var.lb_update_timeout
    delete = var.lb_delete_timeout
  }
}

resource "aws_lb_listener" "http_listener" {
load_balancer_arn =  aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [
    aws_lb_listener.https-listener
  ]
  
}

#data call for certificate
data "aws_acm_certificate" "issued" {
  domain =  "erkai-tentech.com"
  statuses = ["ISSUED"]
}
# Adding https port 443

resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type = "forward"
    target_group_arn = var.target_group_arn
  }
  depends_on = [
aws_lb.lb
 ]
}






/*
resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    type             = var.type
    target_group_arn = var.target_group_arn
  }
}
*/