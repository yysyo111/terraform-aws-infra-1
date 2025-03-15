# モジュールの呼び出し
module "vpc" {
  source = "../../modules/aws/vpc"

  # VPCの変数を設定
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# source = "../../modules/aws/vpc" で VPCのモジュールを呼び出し
# terraform.tfvars の値を渡して 環境ごとに異なる設定ができる

