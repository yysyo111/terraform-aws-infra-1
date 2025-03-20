output "alb_sg_id" {
    description = "ALBのSecurity Group ID"
    value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
    description = "EC2のSecurity Group ID"
    value = aws_security_group.ec2-sg.id
}

output "rds_sg_id" {
    description = "RDSのsecurity Group ID"
    value = aws_security_group.rds_sg.id
}

output "ecs_sg_id" {
  description = "ECSのSecurity Group ID"
  value = aws_security_group.ecs_sg.id
}

