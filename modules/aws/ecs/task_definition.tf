resource "aws_ecs_task_definition" "web_task" {
    family = "web-task"
    execution_role_arn = var.ecs_task_excution_role_arn
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"

    container_definitions = jsonencode([
        {
            name = "web"
            image = var.container_image
            cpu = 256
            memory = 512
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort = 80
                }
            ]
        }
    ])
}