resource "aws_db_instance" "rds" {
    allocated_storage = 20 # 初期ストレージ（GB）
    max_allocated_storage = 100 # 最大ストレージ（Auto Scaling）
    engine = "mysql" # DBエンジン（MySQL）
    engine_version = "8.0" # MySQL のバージョン（最新）
    instance_class = "db.t3.micro" # 小規模向けインスタンスタイプ
    identifier = "dev-rds-instance" # RDSの識別子
    username = var.db_username # DBの管理ユーザー
    password = var.db_password # DBのパスワード（`terraform.tfvars` に記載）
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [var.db_sg_id] # Security Group
    backup_retention_period = 7 # バックアップ保持期間
    skip_final_snapshot = true # 削除時にスナップショットを作成しない
    publicly_accessible = false # パブリックアクセスを無効化

    tags = {
        Name = "dev-rds-instance"
    }
}

# RDS サブネットグループ（Private Subnet に RDS を配置し、Security Group で EC2 からのみ接続可能）
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = var.private_subnet_ids

    tags = {
      Name = "rds-subnet-group"
    }
}

# RDS のユーザー名・パスワードは terraform.tfvars に保存し、直接コードに書かない
# Security Group や Private Subnet の情報を環境変数として管理