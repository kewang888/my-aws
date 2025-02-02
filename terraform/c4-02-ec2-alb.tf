# # ALB Security Group
# resource "aws_security_group" "alb_sg" {
#   vpc_id = module.vpc.vpc_id
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "ALB-SG"
#   }
# }
#
# #---------------- ALB ----------------
# resource "aws_lb" "web_alb" {
#   name               = "web-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = module.vpc.public_subnets
#
#   tags = {
#     Name = "WebALB"
#   }
# }
#
# #---------------- Target Group ----------------
# resource "aws_lb_target_group" "tg" {
#   name     = "web-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
# }
#
# # ALB Listener
# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = 80
#   protocol          = "HTTP"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }
#
# #---------------- Attach EC2 to ALB Target Group ----------------
# resource "aws_lb_target_group_attachment" "tg_attach" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = aws_instance.private_instance.id
#   port             = 80
# }