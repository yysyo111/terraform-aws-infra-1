# --- Launch Template（EC2 インスタンスのテンプレート）---
resource "aws_launch_template" "app" {
    name = "app-launch-template"
    image_id = var.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [var.ec2_sg_id]

    iam_instance_profile {
      name = var.iam_instance_profile_name
    }

    user_data = base64encode(<<-EOF
              #!/bin/bash
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  )
}

# --- Auto Scaling Group（ASG）---
resource "aws_autoscaling_group" "asg" {
    vpc_zone_identifier =  var.private_subnet_ids
    desired_capacity = 1
    min_size = 1
    max_size = 3

    launch_template {
      id = aws_launch_template.app.id
      version = "$Latest"
    }

    # target_group_arns = [var.target_group_arn]

    health_check_type = "EC2"
    health_check_grace_period = 300

    tag {
        key = "Name"
        value = "app-server"
        propagate_at_launch = true
    }
}

#==========================================================================
# ASG のスケールポリシー
#==========================================================================
# スケールアウト（増加）
#==========================================================================
# CPU 使用率が 60% を超えたら 1 台追加
# HTTP リクエスト数（ALB のターゲットグループ）が 2000リクエスト/分 を超えたら 1 台追加
#==========================================================================
# スケールイン（減少）
#==========================================================================
# CPU 使用率が 30% 未満なら 1 台削減
# HTTP リクエスト数（ALB のターゲットグループ）が 500リクエスト/分 未満なら 1 台削減
#==========================================================================
# 必要なリソース
#==========================================================================
# CloudWatch メトリクスを利用して ASG のスケールポリシーを設定
# ターゲット追跡スケーリング（Target Tracking Scaling）を適用
# 最小インスタンス数（min_size）を 1、最大 3 台まで自動調整
#==========================================================================

# --- スケールアウトポリシー（CPU 使用率が 60% を超えたら増加）---
resource "aws_autoscaling_policy" "scale_out_cpu" {
  name                   = "scale-out-cpu"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period            = 60
  statistic        = "Average"
  threshold        = 60  # CPU 60% を超えたらスケールアウト
  alarm_description = "CPU usage exceeds 60%"
  alarm_actions    = [aws_autoscaling_policy.scale_out_cpu.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# --- スケールインポリシー（CPU 使用率が 30% 未満なら減少）---
resource "aws_autoscaling_policy" "scale_in_cpu" {
  name                   = "scale-in-cpu"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period            = 60
  statistic        = "Average"
  threshold        = 30  # CPU 30% 未満ならスケールイン
  alarm_description = "CPU usage below 30%"
  alarm_actions    = [aws_autoscaling_policy.scale_in_cpu.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# --- スケールアウトポリシー（ALB のリクエスト数が 2000 を超えたら増加）---
resource "aws_autoscaling_policy" "scale_out_http" {
  name                   = "scale-out-http"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "http_high" {
  alarm_name          = "http-high-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "RequestCountPerTarget"
  namespace          = "AWS/ApplicationELB"
  period            = 60
  statistic        = "Sum"
  threshold        = 2000  # 2000リクエスト/分 を超えたらスケールアウト
  alarm_description = "High HTTP requests count"
  alarm_actions    = [aws_autoscaling_policy.scale_out_http.arn]
  dimensions = {
    TargetGroup = var.target_group_arn
  }
}

# --- スケールインポリシー（ALB のリクエスト数が 500 未満なら減少）---
resource "aws_autoscaling_policy" "scale_in_http" {
  name                   = "scale-in-http"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "http_low" {
  alarm_name          = "http-low-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name        = "RequestCountPerTarget"
  namespace          = "AWS/ApplicationELB"
  period            = 60
  statistic        = "Sum"
  threshold        = 500  # 500リクエスト/分 未満ならスケールイン
  alarm_description = "Low HTTP requests count"
  alarm_actions    = [aws_autoscaling_policy.scale_in_http.arn]
  dimensions = {
    TargetGroup = var.target_group_arn
  }
}
