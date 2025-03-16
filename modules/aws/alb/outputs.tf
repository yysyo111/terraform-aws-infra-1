output "target_group_arn" {
    description = "ASG に紐づくターゲットグループの ARN"
    value = aws_lb_target_group.tg.arn
}

output "alb_arn" {
    description = "ALB の ARN"
    value = aws_alb.alb.arn
}

output "alb_dns_name" {
    description = "ALB の DNS 名"
    value = aws_alb.alb.dns_name
}

