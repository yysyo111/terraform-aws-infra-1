output "db_username" {
    description = "db_username"
    value = aws_db_instance.rds.username
}

output "db_password" {
    description = "db_password"
    value = aws_db_instance.rds.password
}
output "rds_endpoint" {
    description = "RDSのエンドポイント"
    value = aws_db_instance.rds.endpoint
}

