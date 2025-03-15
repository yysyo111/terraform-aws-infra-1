"# terraform-aws-infra-1" 

## 1.プロジェクトの概要

#### 1. プロジェクト名

terraform-aws-infra-1

#### ディレクトリ構成
```
│── modules/                    # 再利用可能なモジュールを格納
│   ├── aws/                    # AWSサービスごとに分類
│   │   ├── vpc/                # VPC & ネットワークモジュール
│   │   │   ├── main.tf         # VPCリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   │   ├── terraform.tfvars # 設定値
│   │   ├── alb/                # ALBモジュール
│   │   │   ├── main.tf         # ALBリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── autoscaling/        # Auto Scaling モジュール
│   │   │   ├── main.tf         # Auto Scaling Group定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ec2/                # EC2 (Auto Scaling Group 用)
│   │   │   ├── main.tf         # EC2リソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── rds/                # RDS（MySQL/PostgreSQL）
│   │   │   ├── main.tf         # RDSリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── s3_cloudfront/      # S3 + CloudFrontモジュール
│   │   │   ├── main.tf         # S3 & CloudFront定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ecs/                # ECS (Fargate) & ECRモジュール
│   │   │   ├── main.tf         # ECS Cluster & Service
│   │   │   ├── task_definition.tf # ECSタスク定義
│   │   │   ├── ecr.tf          # ECRリポジトリ
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── route53_acm/        # Route 53 + ACM (SSL) モジュール
│   │   │   ├── main.tf         # Route 53 + ACM 設定
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── iam/                # IAMロール & ポリシーモジュール
│   │   │   ├── main.tf         # IAMリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│
│── envs/                       # 環境ごとの設定
│   ├── dev/                    # 開発環境
│   │   ├── main.tf             # Terraformメインファイル
│   │   ├── variables.tf        # 変数定義
│   │   ├── terraform.tfvars    # 開発環境の設定値
│   │   ├── backend.tf          # S3 + DynamoDBでTerraformの状態管理
│   │   ├── provider.tf         # AWSプロバイダー（東京リージョン）
│   ├── prod/                   # 本番環境
│   │   ├── main.tf             # Terraformメインファイル
│   │   ├── variables.tf        # 変数定義
│   │   ├── terraform.tfvars    # 本番環境の設定値
│   │   ├── backend.tf          # S3 + DynamoDBでTerraformの状態管理
│   │   ├── provider.tf         # AWSプロバイダー（東京リージョン）
│
│── scripts/                     # シェルスクリプト（EC2, Nginxセットアップ）
│   ├── nginx_setup.sh           # Nginxインストールスクリプト
│
│── .github/                      # GitHub Actions（CI/CD用）
│   ├── workflows/
│   │   ├── terraform.yml        # Terraform 自動適用ワークフロー
│
│── README.md                     # プロジェクト概要・使い方
│── terraform.tfvars.example       # 設定サンプル
│── .gitignore                     # Git管理から除外するファイル
│── provider.tf                     # AWSプロバイダー設定
│── versions.tf                     # Terraform のバージョン指定
│── variables.tf                     # グローバル変数定義
│── outputs.tf                       # 出力定義
```