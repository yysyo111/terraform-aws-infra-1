variable "db_username" {
    description = "RDSの管理ユーザ名"
    type = string
}

variable "db_password" {
    description = "RDSの管理パスワード"
    type = string
}

variable "private_subnet_ids" {
    description = "RDSを配置するPrivate Subnet ID"
    type = list(string)
}

variable "db_sg_id" {
    description = "RDS用のSecurity Group ID"
    type = string
}

