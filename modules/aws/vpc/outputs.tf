# モジュールから VPC ID を取得するために outputs.tf で vpc_id を出力
# output "vpc_id" により、module.vpc.vpc_id で VPC の ID を取得できるようになる
output "vpc_id" {
    description = "VPC の IDD"
    value = aws_vpc.VPC.id
}

# public_subnet_ids を aws_subnet.public[*].id で定義（リスト形式で取得）
# aws_subnet.public[*].id のようなリスト形式ではなく、個別に [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, ...] のように明示的にリスト化。
output "public_subnet_ids" {
    description = "Public Subnet の ID 一覧"
    value = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id,
        aws_subnet.public_subnet_3.id
    ]
}

# private_subnet_ids を aws_subnet.private[*].id で定義（リスト形式で取得）
output "private_subnet_ids" {
    description = "Private Subnet の ID 一覧"
    value = [
        aws_subnet.private_subnet_1.id,
        aws_subnet.private_subnet_2.id,
        aws_subnet.private_subnet_3.id
    ]
}


