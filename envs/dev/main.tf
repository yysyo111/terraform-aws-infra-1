# モジュールの呼び出し
# source = "../../modules/aws/vpc" で VPCのモジュールを呼び出し
# terraform.tfvars の値を渡して 環境ごとに異なる設定ができる
module "vpc" {
  source = "../../modules/aws/vpc"

  # VPCの変数を設定
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Security Group モジュールを呼び出す
# envs/dev/main.tf で module.vpc の vpc_id を呼び出し、Security Group モジュールに渡す
# Security Group モジュールの variables.tf で vpc_id を受け取ります。
module "security_groups" {
  source = "../../modules/aws/security_groups"

  vpc_id = module.vpc.vpc_id
  db_port = 3306
}

module "iam" {
  source = "../../modules/aws/iam"
}

