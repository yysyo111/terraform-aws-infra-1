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


# envs/dev/main.tf で modules/aws/ec2/ を呼び出し、EC2 を作成
# module "ec2" {
#   source = "../../modules/aws/ec2"

#   ami_id = "ami-0599b6e53ca798bb2" # 適切な AMI ID を指定
#   instance_type = "t2.micro"
#   private_subnet_id = module.vpc.private_subnet_ids[0] ## VPC モジュールから Private Subnet ID を取得
#   ec2_sg_id = module.security_groups.ec2_sg_id # Security Group モジュールから取得
#   iam_instance_profile_name = module.iam.ec2_ssm_profile_name # IAM モジュールから取得
# }

# envs/dev/main.tf で EC2 に必要な値を渡す
# module.vpc, module.security_groups, module.iam から適切な情報を取得して渡す
# module.vpc.private_subnet_ids[0] が modules/aws/vpc/outputs.tf で定義されるようになった

module "alb" {
  source = "../../modules/aws/alb"

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id = module.security_groups.alb_sg_id
}

module "autoscaling" {
  source = "../../modules/aws/autoscaling"

  ami_id = "ami-0599b6e53ca798bb2"
  instance_type = "t2.micro"
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id = module.security_groups.ec2_sg_id
  iam_instance_profile_name = module.iam.ec2_ssm_profile_name
  target_group_arn = module.alb.target_group_arn
}

module "rds" {
  source = "../../modules/aws/rds"

  db_username = var.db_username
  db_password = var.db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id = module.security_groups.rds_sg_id
}


module "ecs" {
  source = "../../modules/aws/ecs"

  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id = module.security_groups.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
  container_image = module.ecs.aws_ecr_repository_url
  ecs_task_excution_role_arn = module.iam.ecs_task_execution_role_arn
}

