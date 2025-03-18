# Create a Security Group for ALB
resource "aws_security_group" "internal_alb2_sg" {
  name   = "internal_alb2_sg"
  vpc_id = module.vpc2.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this based on your needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an Internal ALB
resource "aws_lb" "internal_alb2" {
  name               = "my-internal-alb2"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb2_sg.id]
  subnets            = module.vpc2.private_subnets
}

# Create a Target Group (Unused, but required)
resource "aws_lb_target_group" "dummy_tg2" {
  name     = "dummy-target-group2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc2.vpc_id
}

# Create a Listener with a Fixed Response
resource "aws_lb_listener" "http_listener2" {
  load_balancer_arn = aws_lb.internal_alb2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, World from internal_alb2"
      status_code  = "200"
    }
  }
}