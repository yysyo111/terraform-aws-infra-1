variable "private_subnet_ids" {
    description = "ECSのサブネットID"
    type = list(string)
}

variable "ecs_sg_id" {
    description = "ECSのSecurity Group ID"
    type = string
}

variable "target_group_arn" {
    description = "ALBのターゲットグループARN"
    type = string
}

variable "container_image" {
    description = "ECSのDockerイメージ"
    type = string
}

variable "ecs_task_excution_role_arn" {
    description = "ECSタスク実行ロールARN"
    type = string
}

