# モジュールから VPC ID を取得するために outputs.tf で vpc_id を出力
# output "vpc_id" により、module.vpc.vpc_id で VPC の ID を取得できるようになる
output "vpc_id" {
    description = "作成されたVPCのID"
    value = aws_vpc.VPC.id
}
