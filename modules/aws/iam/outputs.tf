output "aws_ssm_role_name" {
    description = "EC2 の Session Manager 用 IAM ロール名"
    value = aws_iam_role.ec2_ssm_role.name
}

output "ec2_ssm_profile_name" {
    description = "EC2 の Session Manager 用 IAM インスタンスプロファイル名"
    value = aws_iam_instance_profile.ec2_ssm_profile.name
}

output "ecs_task_execution_role_arn" {
  description = "ECS タスク実行ロール ARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}