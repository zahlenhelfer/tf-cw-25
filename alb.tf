resource "aws_security_group" "alb" {
  name        = "alb-security-allow-http"
  description = "Terraform load balancer security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-allow-http"
  }
}

resource "aws_alb" "alb" {
  name            = "terraform-example-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = module.vpc.public_subnets.*
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.web-group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "web-group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "alb-attachment" {
  count            = var.instance_count
  target_group_arn = aws_alb_target_group.web-group.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
