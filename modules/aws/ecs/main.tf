# ECSクラスターの作成
resource "aws_ecs_cluster" "main" {
    name = "dev-ecs-cluster"
}

# ECSサービスの作成
resource "aws_ecs_service" "web_service" {
    name            = "web-service"
    cluster        = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.web_task.arn
    launch_type    = "FARGATE"
    desired_count  = 2

    network_configuration {
        subnets         = var.private_subnet_ids
        security_groups = [var.ecs_sg_id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.target_group_arn
        container_name   = "web"
        container_port   = 80
    }

    depends_on = [aws_ecs_task_definition.web_task]
}





