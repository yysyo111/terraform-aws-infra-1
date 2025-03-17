# --- ALB の Security Group ---

resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id

    # HTTP（80）許可 自分のグローバルIPアドレスのみにする？
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP（443）許可 自分のグローバルIPアドレスのみにする？
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "alb-security-group"
    }
}

# --- EC2 の Security Group ---
resource "aws_security_group" "ec2-sg" {
    vpc_id = var.vpc_id

    # HTTP (80) 許可（ALB からの通信のみ） これはHTTPのみ？
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    # 外部への通信を許可（アップデートなどのため）
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ec2-security-group"
    }
}

# --- RDS の Security Group ---
resource "aws_security_group" "rds_sg" {
    name = "rds-sg"
    description = "RDS security group"
    vpc_id = var.vpc_id

    # MySQL (3306) / PostgreSQL (5432) 許可（EC2 からのみ）
    ingress {
        from_port = var.db_port
        to_port = var.db_port
        protocol = "tcp"
        security_groups = [aws_security_group.ec2-sg.id]
    }

    # RDS からの通信をすべて許可（管理用）
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-sg"
    }
}

