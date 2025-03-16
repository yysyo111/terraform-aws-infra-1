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

    target_group_arns = [var.target_group_arn]

    health_check_type = "EC2"
    health_check_grace_period = 300

    tag {
        key = "Name"
        value = "app-server"
        propagate_at_launch = true
    }
}

