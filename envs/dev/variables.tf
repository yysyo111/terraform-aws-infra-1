variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "azs" {
  description = "使用するアベイラビリティゾーン"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public SubnetのCIDRリスト"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private SubnetのCIDRリスト"
  type        = list(string)
}

# ここでは「定義」だけで、「値」は書かない！
# 設定値（CIDR, AZ など）は terraform.tfvars に書く！

variable "db_username" {
    description = "RDSの管理ユーザ名"
    type = string
}

variable "db_password" {
    description = "RDSの管理パスワード"
    type = string
    sensitive = true
}