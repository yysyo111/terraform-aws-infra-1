# provider.tf は環境ごとに envs/dev/ に作成するのが基本
# 異なる AWS リージョン（例: ap-northeast-1 → us-east-1）を使う場合は、 envs/prod/ にも別途作成

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1" # 東京リージョン（環境ごとに変更可能）
}

# この provider.tf を envs/dev/ に配置すれば、Terraform が AWS に接続できるようになる
# region を us-east-1 に変えれば、 envs/prod/provider.tf で別リージョンを適用可能

