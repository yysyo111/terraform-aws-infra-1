# --- EC2 インスタンス ---
# EC2 は Private Subnet に配置
# ALB からの HTTP (80) のみ許可（Security Group 設定済み）
# IAM インスタンスプロファイルで Session Manager を使用
# User Data で Nginx を自動インストール & 起動
# -----------------------
# resource "aws_instance" "app_server" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     # subnet_id = module.vpc.private_subnet_ids[0] # Private Subnet に配置
#     subnet_id = var.private_subnet_id # `module.vpc.private_subnet_ids[0]` → `var.private_subnet_id`
#     # vpc_security_group_ids = [module.security_groups.ec2_sg_id]
#     vpc_security_group_ids = [var.ec2_sg_id] #  `module.security_groups.ec2_sg_id` → `var.ec2_sg_id`
#     # iam_instance_profile = module.iam.ec2_ssm_profile_name
#     iam_instance_profile = var.iam_instance_profile_name #`module.iam.ec2_ssm_profile_name` → `var.iam_instance_profile_name`

#     # User Data（初回起動時にNginxをインストール）
#     user_data = <<-EOF
#                 #!/bin/bash
#                 amazon-linux-extras enable nginx1
#                 yum install -y nginx
#                 systemctl start nginx
#                 systemctl enable nginx
#                 EOF
    
#     tags = {
#       Name = "app-server"
#     }
# }


