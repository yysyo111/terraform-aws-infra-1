# terraform-aws-infra-1

## **1. プロジェクトの概要**

Terraform を用いて AWS の ECS(Fargate)環境を主に構築したプロジェクトです。

- **VPC / Subnet / RouteTable / NAT Gateway / IGW のネットワーク構成**
- **ECS (Fargate) + ALB による Web アプリケーションの公開**
- **ECR に push した Docker イメージを ECS 上で実行**
- **RDS (MySQL) の構築と接続**

---

## **2. 使用技術**

### **インフラ構成技術（使用技術）**

- **クラウド基盤:** AWS（東京リージョン）
- **ネットワーク:** VPC, Public/Private Subnet, IGW, NAT Gateway, Route Table
- **コンテナ:** ECS (Fargate), ECR, ALB
- **データベース:** RDS (MySQL)
- **セキュリティ:** IAMロール、セキュリティグループ
- **IaC:** Terraform（モジュール構成）
- **デプロイ:** Docker & GitHub Actions（ECR Push & ECS Deploy）

### 今後の実装予定

- Route53 + ACM による独自ドメイン/HTTPS 対応
- S3 + CloudFront による静的コンテンツ配信
- CloudWatch Logs / Metrics 連携
- GitHub Actions による CI/CD 自動化

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
│   │   ├── s3_cloudfront/    　# S3 + CloudFrontモジュール
│   │   │   ├── main.tf         # S3 + CloudFrontリソース定義
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── ecs/                # ECS (Fargate) & ECRモジュール
│   │   │   ├── main.tf         # ECS Cluster & Service
│   │   │   ├── task_definition.tf # ECSタスク定義
│   │   │   ├── ecr.tf          # ECRリポジトリ
│   │   │   ├── variables.tf    # 変数定義
│   │   │   ├── outputs.tf      # 出力定義
│   │   ├── (route53_acm/)      # Route 53 + ACM (SSL) モジュール（未実装）
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
│── .github/                    # GitHub Actions（CI/CD用）（未実装）
│   ├── workflows/
│   │   ├── terraform.yml       # Terraform 自動適用ワークフロー
│
│── README.md                   # プロジェクト概要・使い方
│── .gitignore                  # Git管理から除外するファイル
│── provider.tf                 # AWSプロバイダー設定
│── app
│   ├── Dockerfile              # ECS(Nginx)用Dockerfile
│   ├── html/                   # ECSコンテナに組み込むWebコンテンツディレクトリ
│   │   ├── index.html          # Webコンテンツ用HTMLファイル
│   ├── static/                 # 静的コンテンツディレクトリ
│   │   ├── index.html          # 静的コンテンツ用HTMLファイル
```

#### 4. 構築手順
1. **VPC・サブネットの構成**

   - VPC（10.0.0.0/16）を作成
   - Public / Private サブネットを AZ ごとに3つずつ作成
   - Public サブネットには IGW（インターネットゲートウェイ）を接続
   - Private サブネットから外部接続するため NAT Gateway を作成

2. **Route Table の設定**

   - パブリックサブネット ⇒ IGW 経由で通信可能に設定
   - プライベートサブネット ⇒ NAT Gateway 経由で外部通信可能に設定

3. **Security Group の設定**

   - ALB → 0.0.0.0/0 の HTTP/HTTPS 許可
   - ECS → ALB からの HTTP 許可
   - RDS → ECS からの接続のみ許可（MySQL ポート）

4. **IAM ロール**

   - ECS タスク用の実行ロールを作成（AmazonECSTaskExecutionRolePolicy をアタッチ）
   - Session Manager で EC2 を使わずコンテナ内にアクセスする構成

5. **RDS（MySQL）の構築**

   - Private Subnet に配置、セキュアに構成
   - Terraform による DB ユーザー、パスワード定義（変数化）

6. **ECS（Fargate）+ ECR の構築**

   - ECR に Web アプリ（nginx）の Docker イメージを push
   - ECS タスク定義に image を指定し、ALB 経由で公開
   - タスク定義にポート 80 をマッピング

7. **Docker イメージのビルド & デプロイ**

   ```bash
   # Dockerイメージの作成
   docker build -t web-app .

   # ECR にログイン（AWS CLI）
   aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin [account_id].dkr.ecr.ap-northeast-1.amazonaws.com

   # ECR向けにタグ付け
   docker tag web-app:latest [account_id].dkr.ecr.ap-northeast-1.amazonaws.com/web-app:latest

   # ECRへPush
   docker push [account_id].dkr.ecr.ap-northeast-1.amazonaws.com/web-app:latest

   # ECS サービスの強制デプロイ（更新）
   aws ecs update-service --cluster dev-ecs-cluster --service web-service --force-new-deployment

   # ALB の DNS を通して Web アプリにアクセスできるか確認

8. **CI/CD & 自動デプロイ（未実装）**
   - GitHub Actions による Terraform Plan / Apply 自動化
   - Docker build → ECR push → ECS deploy の自動化パイプライン構築

#### 5. リソース削除（クリーンアップ手順）
1. **リソース削除（クリーンアップ手順）**
   ```bash
   # 開発環境フォルダに移動
   cd envs/dev

   # Terraformで削除
   terraform destroy -auto-approve

   # Dockerイメージ削除
   docker image rm web-app:latest

   # ECR内のイメージ削除
   aws ecr batch-delete-image --repository-name web-app --image-ids imageTag=latest

   # ECRリポジトリ自体を削除（中身が空である必要あり）
   aws ecr delete-repository --repository-name web-app

#### 6. 静的コンテンツファイルアップロードコマンド
1. **静的コンテンツファイルアップロード**
   ```bash
   # 静的コンテンツフォルダに移動
   cd app/static/

   # アップロードコマンド
   aws s3 cp app/static/ s3://terrfrom-s3-bucket-yoshi2025 --recursive