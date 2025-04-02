# terraform-aws-infra-1

## **1. プロジェクトの概要**
Terraform を用いて AWS インフラをコードで管理するプロジェクトです。
VPC、ECS（Fargate）、RDS（MySQL）などを構築し、将来的には GitHub Actions を用いた CI/CD の自動化も予定しています。

---

## **2. 使用技術**

### **Infrastructure**
- **Cloud Provider:** Amazon Web Services (AWS)
- **VPC & Networking:** VPC, Subnet (Public & Private), Internet Gateway (IGW), NAT Gateway, Route Table, Elastic IP
- **Load Balancing:** AWS Application Load Balancer (ALB)
- **Container Orchestration:** Amazon ECS (Fargate), Amazon ECR
- **Storage:** Amazon S3, AWS CloudFront (CDN)（予定）
- **Security:** AWS IAM, Security Group
- **DNS & SSL:** Amazon Route 53, AWS Certificate Manager (ACM)（予定）

### **Database**
- **Managed Database:** Amazon RDS (MySQL)

### **Monitoring & Logging**
- **Monitoring:** Amazon CloudWatch (Metrics, Logs, Alarms)（予定）
- **Alerting:** AWS SNS（予定）

### **Infrastructure as Code (IaC)**
- **IaC Tool:** Terraform
- **State Management:** 未定（S3予定）
- **Configuration Management:** Terraform Modules

### **Deployment & CI/CD**
- **CI/CD Pipeline:** GitHub Actions
- **Docker:** ECR への push

### **Security & Compliance**
- **IAM Policies:** Least Privilege Access（最小権限アクセス）
- **Networking Security:** Security Groups, IAM Roles

### **その他**
- **Code Repository:** GitHub
- **GitHub Actions Workflows:** Terraform Plan & Apply, Docker Image Build & Push（予定）

---

#### 3. ディレクトリ構成
```plaintext
│── modules/                    # 再利用可能なモジュールを格納
│   ├── aws/                    # AWSサービスごとに分類
│   │   ├── vpc/                # VPC & ネットワークモジュール
│   │   │   ├── main.tf         # VPCリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── security_groups/    # security_groupsモジュール
│   │   │   ├── main.tf         # security_groupsの定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義（Security Group ID）
│   │   ├── alb/                # ALBモジュール
│   │   │   ├── main.tf         # ALBリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── rds/                # RDS（MySQL）
│   │   │   ├── main.tf         # RDSリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── s3_cloudfront/      # S3 + CloudFrontモジュール（未実装）
│   │   │   ├── main.tf         # S3 & CloudFront定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ecs/                # ECS (Fargate) & ECRモジュール
│   │   │   ├── main.tf         # ECS Cluster & Service
│   │   │   ├── task_definition.tf # ECSタスク定義
│   │   │   ├── ecr.tf          # ECRリポジトリ
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── route53_acm/        # Route 53 + ACM (SSL) モジュール（未実装）
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
│   ├── prod/                   # 本番環境（未実装）
│
│── .github/                      # GitHub Actions（CI/CD用）（未実装）
│   ├── workflows/
│   │   ├── terraform.yml        # Terraform 自動適用ワークフロー
│
│── README.md                     # プロジェクト概要・使い方
│── .gitignore                     # Git管理から除外するファイル
│── provider.tf                     # AWSプロバイダー設定
│── app
│   ├── Dockerfile
│   ├── html
```

#### 4. 構築手順
```plaintext
1. VPC・サブネットの構成
- VPC（10.0.0.0/16）を作成
- Public / Private サブネットを AZ ごとに3つずつ作成
- Public サブネットには IGW（インターネットゲートウェイ）を接続
- Private サブネットから外部接続するため NAT Gateway を作成

2. Route Table の設定
- Public 向けに IGW 経由のルート、Private 向けに NAT Gateway 経由のルートを作成

3. Security Group の設定
- ALB → 0.0.0.0/0 の HTTP/HTTPS 許可
- ECS → ALB からの HTTP 許可
- RDS → ECS からの接続のみ許可（MySQL ポート）

4. IAM ロール
- ECS タスク用の実行ロール（AmazonECSTaskExecutionRolePolicy など）を作成
- Session Manager で EC2 を使わずコンテナ内にアクセスする構成

5. RDS（MySQL）の構築
- Private Subnet に配置、セキュアに構成
- Terraform による DB ユーザー、パスワード定義（変数化）

6. ECS（Fargate）+ ECR の構築
- ECR に Web アプリ（nginx）の Docker イメージを push
- ECS タスク定義に image を指定し、ALB 経由で公開
- タスク定義にポート 80 をマッピング

7. Docker イメージのビルド & デプロイ
- # Docker image build & push
- `docker build -t web-app .`
- `docker tag web-app:latest [account_id].dkr.ecr.ap-northeast-1.amazonaws.com/web-app:latest`
- `docker push [account_id].dkr.ecr.ap-northeast-1.amazonaws.com/web-app:latest`
- # ECS service update
- `aws ecs update-service --cluster dev-ecs-cluster --service web-service --force-new-deployment`

5. CI/CD & 自動デプロイ（未実装）
・GitHub Actions を用いた Terraform の Plan & Apply 自動実行
・Docker イメージのビルド & Amazon ECR への Push
```

