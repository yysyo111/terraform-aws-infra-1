# ECS クラスター・サービス名・ECR リポジトリの URL を出力
output "ecs_cluster_id" {
    value = aws_ecs_cluster.main.id
}

output "ecs_service_name" {
    value = aws_ecs_service.web_service.name
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.web.repository_url
}
