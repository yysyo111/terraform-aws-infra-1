# VPCの作成
resource "aws_vpc" "VPC" {
    cidr_block = var.vpc_cidr #terraform.tfvars に書いた値（例: 10.0.0.0/16）を使用
    enable_dns_support = true #AWS 内で DNS を使えるようにする
    enable_dns_hostnames = true # EC2 にホスト名を付与できるようにする

    # タグ（tags）を付けて管理しやすくする
    tags = {
        Name = "dev-vpc"
        Enviroment = "dev"
    }
}

# Public Subnet（インターネットに出られる）
resource "aws_subnet" "public_subnet_1" { #aws_subnet で Public Subnet を作成
    vpc_id = aws_vpc.VPC.id #作成した VPC の ID を指定
    cidr_block = var.public_subnet_cidrs[0] #terraform.tfvars で指定した CIDR を使用
    availability_zone = var.azs[0] 
    map_public_ip_on_launch = true #EC2 を作ったときに自動でパブリック IP を付与（外部アクセス OK）

    tags = {
        Name = "dev-public-subnet-1"
    }
}

# Public Subnet（インターネットに出られる）
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_subnet_cidrs[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet-3"
  }
}
# Public Subnet を 3つ 作成（各 AZ に配置）
# map_public_ip_on_launch = true で EC2 などに自動で Public IP を付与

# Private Subnet の作成（3つ）
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "dev-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "dev-private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnet_cidrs[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "dev-private-subnet-3"
  }
}
# Private Subnet も 3つ 作成（各 AZ に配置）
# map_public_ip_on_launch はデフォルト false（インターネットに直接アクセス不可）




# Internet Gateway（IGW）の作成（Public Subnet に接続することで、インターネットに出られる）
resource "aws_internet_gateway" "igw" { #IGW（インターネットゲートウェイ）を作成
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = "dev-igw"
    }
}

# NAT Gateway（Private Subnet用）
resource "aws_eip" "nat_eip" { #固定IP（Elastic IP）を取得
    # domain = "VPC" # これは誤り
    domain = "vpc"  # 小文字の "vpc" に修正
}
# Terraform の aws_eip リソースで domain の値は "vpc" または "standard" のどちらかでなければならず、大文字の "VPC" は無効です。

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet_1.id #Public Subnet に NAT Gateway を配置

    tags = {
        Name = "dev-nat-gw"
    }
}

# --- Public Route Table ---
# Public Route Table を作成
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "dev-public-rt"
  }
}  

# Public Route Table に Internet Gateway を追加（外部通信可能）
# Internet Gateway へのルートを追加
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# Public Subnet に Public Route Table を関連付け
# 各 Subnet に適切な Route Table を関連付ける
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_3_association" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}

# --- Private Route Table ---
# Private Route Table を作成
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "dev-private-rt"
  }
}

# Private Route Table に NAT Gateway を追加（外部通信可能にする）
# NAT Gateway へのルートを追加
resource "aws_route" "private_nat_access" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

# Private Subnet に Private Route Table を関連付け
# 各 Subnet に適切な Route Table を関連付ける
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_3_association" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}

