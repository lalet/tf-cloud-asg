resource "aws_elb" "elb" {
  name               = format("terraform-elb-%s", var.env)
  security_groups    = var.security_group_ids
  availability_zones = var.aws_availability_zones
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = "80"
    instance_protocol  = "http"
    ssl_certificate_id = var.ssl_certificate_id
  }
}