# --- ALB の作成 ---
resource "aws_alb" "alb" {
    name = "app-load-balancer" # ALB の名前
    internal = false # インターネットからアクセス可能なパブリック ALB が作成
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.public_subnet_ids

    enable_deletion_protection = false # ALB は削除可能

    tags = {
        Name = "app-load-balancer"
    }
}

# --- ターゲットグループ（ASG の EC2 を登録）---
resource "aws_lb_target_group" "tg" {
    name = "app-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = "/"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }

    tags = {
        Name = "app-target-group"
    }
}

# --- ALB の HTTP リスナー（リクエストをターゲットグループへ転送）---
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}

