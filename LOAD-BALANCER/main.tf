# CREATING PRIVATE LOAD BALANCER

resource "aws_lb" "Private-Load-Balancer-Internal" {
  name               = "Internal Load Balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.Inter-LB-SG_id]
  subnets            = [var.Private_Subnet_AZ1_id, var.Private_Subnet_AZ2_id]
}


# CREATING TARGET GROUP

resource "aws_lb_target_group" "Private-Target-Group" {
  name     = "Target-Group"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.VPC-id
  target_type = instance

  health_check {
    protocol = "HTTP"
#    path     = 
  }
}

# CREATING LISTNER

resource "aws_lb_listener" "Listner" {
  load_balancer_arn = aws_lb.app_tier_internal_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Private-Target-Group.arn
  }
}