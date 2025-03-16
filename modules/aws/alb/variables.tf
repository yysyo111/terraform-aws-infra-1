variable "alb_sg_id" {
    description = "ALBのSecurity Group ID"
    type = string
}

variable "public_subnet_ids" {
    description = "ALBを配置するPublic SubnetのIDリスト"
    type = list(string)
}

variable "vpc_id" {
    description = "VPC の ID"
    type = string
}
