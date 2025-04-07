output "role_arn" {
  description = "OIDC用IAMロールのARN"
  value       = aws_iam_role.github_actions_oidc.arn
}