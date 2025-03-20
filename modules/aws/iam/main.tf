# --- IAM ロール（Session Manager 用）---
resource "aws_iam_role" "ec2_ssm_role" {
    name = "ec2-session-manager-role"

    # Terraform 公式ドキュメントの推奨通り、jsonencode() を使用するのがベストプラクティス
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    })
}

# --- Session Manager 用のポリシーをアタッチ ---
resource "aws_iam_policy_attachment" "ssm_attachment" {
    name = "ec2-ssm-policy-attachment"
    roles =[aws_iam_role.ec2_ssm_role.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --- IAM インスタンスプロファイル（EC2 にロールを適用するため）---
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
    name = "ec2-ssm-profile"
    role = aws_iam_role.ec2_ssm_role.name
}

# ECS タスク実行ロール
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "ecs-task-execution-role"
  }
}

# ECS タスク実行ロールに必要なポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
