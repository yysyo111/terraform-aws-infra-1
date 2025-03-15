variable "vpc_cidr" {
    description = "VPCのCIDRブロック"
    type = string
}

variable "azs" {
    description = "使用するアベイラビリティゾーン"
    type = list(string)
}

variable "public_subnet_cidrs" {
    description = "Public SubnetのCIDRリスト"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "Private SubnetのCIDRリスト"
    type = list(string) 
}

# variables.tf では、外部から値を受け取るための変数を定義
# type = string（文字列）や type = list(string)（リスト）で型を指定
# 実際の値は terraform.tfvars に書く
# この variables.tf は「変数の定義」だけなので、このまま envs/dev/variables.tf にコピーしてOK
