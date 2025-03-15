# terraform-aws-infra-1

## **1. プロジェクトの概要**
Terraform を用いて AWS インフラをコードで管理するプロジェクトです。  
VPC、EC2、RDS、ECS などを構築し、GitHub Actions を用いた CI/CD を適用します。

---

## **2. 使用技術**

### **Infrastructure**
- **Cloud Provider:** Amazon Web Services (AWS)
- **VPC & Networking:** VPC, Subnet (Public & Private), Internet Gateway (IGW), NAT Gateway, Route Table, Elastic IP
- **Compute:** Amazon EC2, Auto Scaling Group (ASG), AWS Lambda (予定)
- **Load Balancing:** AWS Application Load Balancer (ALB)
- **Container Orchestration:** Amazon ECS (Fargate), Amazon ECR
- **Storage:** Amazon S3, AWS CloudFront (CDN)
- **Security:** AWS IAM, Security Group, AWS KMS (予定)
- **DNS & SSL:** Amazon Route 53, AWS Certificate Manager (ACM)

### **Database**
- **Managed Database:** Amazon RDS (MySQL, PostgreSQL)
- **Backup:** AWS Backup（予定）

### **Monitoring & Logging**
- **Monitoring:** Amazon CloudWatch (Metrics, Logs, Alarms)
- **Logging:** AWS CloudTrail（予定）, Amazon S3 Logs
- **Alerting:** AWS SNS（予定）

### **Infrastructure as Code (IaC)**
- **IaC Tool:** Terraform
- **State Management:** 未定（S3 + DynamoDB 予定）
- **Configuration Management:** Terraform Modules
- **Provisioning:** AWS Systems Manager（予定）

### **Deployment & CI/CD**
- **CI/CD Pipeline:** GitHub Actions
- **Container Management:** Docker, Amazon ECR

### **Security & Compliance**
- **IAM Policies:** Least Privilege Access（最小権限アクセス）
- **Networking Security:** Security Groups, IAM Roles
- **Vulnerability Scanning:** Amazon Inspector（予定）
- **WAF & DDoS Protection:** AWS WAF, AWS Shield（予定）

### **その他**
- **Backend:** 未定（Lambda/API Gateway 予定）
- **Environment setup:** Docker（AWS ECS）
- **Code Repository:** GitHub
- **GitHub Actions Workflows:** Terraform Plan & Apply, Docker Image Build & Push

---

#### 3. ディレクトリ構成
```plaintext
│── modules/                    # 再利用可能なモジュールを格納
│   ├── aws/                    # AWSサービスごとに分類
│   │   ├── vpc/                # VPC & ネットワークモジュール
│   │   │   ├── main.tf         # VPCリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   │   ├── terraform.tfvars # 設定値
│   │   ├── alb/                # ALBモジュール
│   │   │   ├── main.tf         # ALBリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── autoscaling/        # Auto Scaling モジュール
│   │   │   ├── main.tf         # Auto Scaling Group定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ec2/                # EC2 (Auto Scaling Group 用)
│   │   │   ├── main.tf         # EC2リソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── rds/                # RDS（MySQL/PostgreSQL）
│   │   │   ├── main.tf         # RDSリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── s3_cloudfront/      # S3 + CloudFrontモジュール
│   │   │   ├── main.tf         # S3 & CloudFront定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ecs/                # ECS (Fargate) & ECRモジュール
│   │   │   ├── main.tf         # ECS Cluster & Service
│   │   │   ├── task_definition.tf # ECSタスク定義
│   │   │   ├── ecr.tf          # ECRリポジトリ
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── route53_acm/        # Route 53 + ACM (SSL) モジュール
│   │   │   ├── main.tf         # Route 53 + ACM 設定
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── iam/                # IAMロール & ポリシーモジュール
│   │   │   ├── main.tf         # IAMリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│
│── envs/                       # 環境ごとの設定
│   ├── dev/                    # 開発環境
│   │   ├── main.tf             # Terraformメインファイル
│   │   ├── variables.tf        # 変数定義
│   │   ├── terraform.tfvars    # 開発環境の設定値
│   │   ├── backend.tf          # S3 + DynamoDBでTerraformの状態管理
│   │   ├── provider.tf         # AWSプロバイダー（東京リージョン）
│   ├── prod/                   # 本番環境
│   │   ├── main.tf             # Terraformメインファイル
│   │   ├── variables.tf        # 変数定義
│   │   ├── terraform.tfvars    # 本番環境の設定値
│   │   ├── backend.tf          # S3 + DynamoDBでTerraformの状態管理
│   │   ├── provider.tf         # AWSプロバイダー（東京リージョン）
│
│── scripts/                     # シェルスクリプト（EC2, Nginxセットアップ）
│   ├── nginx_setup.sh           # Nginxインストールスクリプト
│
│── .github/                      # GitHub Actions（CI/CD用）
│   ├── workflows/
│   │   ├── terraform.yml        # Terraform 自動適用ワークフロー
│
│── README.md                     # プロジェクト概要・使い方
│── terraform.tfvars.example       # 設定サンプル
│── .gitignore                     # Git管理から除外するファイル
│── provider.tf                     # AWSプロバイダー設定
│── versions.tf                     # Terraform のバージョン指定
│── variables.tf                     # グローバル変数定義
│── outputs.tf                       # 出力定義
```

#### 4. 構築手順
```plaintext
1. VPC & サブネットの構成
・CIDR: 10.0.0.0/16 のVPCを作成
・Public & Private Subnetをそれぞれ3つずつ作成（3つのAZ対応）
・Public SubnetにInternet Gatewayを接続（ALB配置）
・Private SubnetにNAT Gatewayを経由する設定（EC2用）

2. Route Table の設定 & 適用
・Public Subnet 用のルートテーブル（外部と通信可能）
・Private Subnet 用のルートテーブル（NAT Gateway 経由で外部通信）
・Terraform で自動適用する

3. Security Group の設定 & 適用
・ALB, EC2, RDS などの通信ルールを設定
・SSH, HTTP, HTTPS の許可範囲を明確化
・Terraform で IAM ロール & ポリシーと合わせて適用する

4. EC2 の構築
・Auto Scaling Group（ASG）を使うか？ 単一 EC2 インスタンスを作るか？
・Terraform の modules/aws/ec2/ にモジュールを作成
・ユーザーデータ（user_data）で初期設定（Nginx インストールなど）
・ALB（ロードバランサー）と連携するか？

5. CI/CD & 自動デプロイ
・GitHub Actions を用いた Terraform の Plan & Apply 自動実行
・Docker イメージのビルド & Amazon ECR への Push
```

#### 5. パラメータ値
```plaintext
VPC
```
| TH 項目 | TH 設定値 | TH 備考 |
| :--- | :---  | :---  |
| VPC名 | dev-vpc |  |
| CIDR | 10.0.0.0/16 |  |

```plaintext
サブネット
```

```plaintext
インターネットゲートウェイ
```

```plaintext
NatGateway
```

```plaintext
Elastic IP
```




