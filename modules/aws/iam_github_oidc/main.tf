resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions_oidc" {
    name = "GitHubActionsOIDCRole-${var.environment}"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github.arn
                },
                Action = "sts:AssumeRoleWithWebIdentity",
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
                        "token.actions.githubusercontent.com:sub" = "repo:${var.repository}:ref:refs/heads/main"
                    }
                }
            }
        ]
    })
}

resource "aws_iam_policy" "s3_upload_policy" {
    name        = "GitHubActionsS3UploadPolicy-${var.environment}"
    description = "Allow GitHub Actions to upload to S3"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow",
                Action   = [
                    "s3:PutObject",
                    "s3:PutObjectAcl",
                    "s3:DeleteObject",
                    "s3:ListBucket"
                ],
                Resource = [
                    "arn:aws:s3:::${var.bucket_name}",
                    "arn:aws:s3:::${var.bucket_name}/*"
                ]
            },
            {
                Effect   = "Allow",
                Action   = "cloudfront:CreateInvalidation",
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}