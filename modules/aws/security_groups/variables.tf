# envs/dev/main.tf で module.vpc.vpc_id を渡し、Security Group モジュール内で variable "vpc_id" として受け取る。
variable "vpc_id" {
    description = "VPCのID"
    type = string
}

variable "db_port" {
    description = "データベースのポート番号"
    type = number
}
