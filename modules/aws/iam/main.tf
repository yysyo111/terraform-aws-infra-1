# --- IAM ロール（Session Manager 用）---
resource "aws_iam_role" "ec2_ssm_role" {
    name = "ec2-session-manager-role"

    # assume_role_policy = jsonencode({
    #     Version = "2012-10-17"
    #     Statement = [{
    #         Effect = "Allow"
    #         Principal = {
    #             Service = "ec2.amazonaws.com"
    #         }
    #         Action = "sts:AssumeRole"
    #     }]
    # })
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
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
