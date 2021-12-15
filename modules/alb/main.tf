#
# Jalgraves 2021
#

data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = var.name
  vpc_id             = var.vpc_id
  security_groups    = var.security_groups
  subnets            = var.subnets
  target_groups      = var.target_groups
  http_tcp_listeners = var.http_tcp_listeners
}

resource "aws_lb_target_group" "k8s" {
  name     = "${var.name}-k8s-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/healthz"
    port                = 30080
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "404"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.alb.lb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s.arn
  }
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = module.alb.lb_arn
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
}

resource "aws_lb_target_group_attachment" "control_plane" {
  target_group_arn = aws_lb_target_group.k8s.arn
  target_id        = var.control_plane_id
  port             = 30080
}

resource "aws_lb_target_group_attachment" "worker" {
  target_group_arn = aws_lb_target_group.k8s.arn
  target_id        = var.worker_id
  port             = 30080
}
