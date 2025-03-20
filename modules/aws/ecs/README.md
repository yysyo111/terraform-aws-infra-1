-----------------------------
|ディレクトリ構成            |
-----------------------------
│── modules/aws/
│   ├── ecs/                     # ECS (Fargate) & ECR モジュール
│   │   ├── main.tf               # ECS Cluster & Service
│   │   ├── task_definition.tf    # ECS タスク定義
│   │   ├── ecr.tf                # ECR リポジトリ
│   │   ├── variables.tf          # 変数定義
│   │   ├── outputs.tf            # 出力定義
│── envs/dev/
│   ├── main.tf                   # Terraformメインファイル（ECS を呼び出す）
│   ├── variables.tf               # 変数定義
│   ├── terraform.tfvars          # 設定値
│   ├── backend.tf                # S3 + DynamoDBでTerraformの状態管理
│   ├── provider.tf               # AWSプロバイダー

・modules/aws/ecs/にECS（Fargate）関連のモジュールを作成
・envs/dev/でTerraformのmodule "ecs"で呼び出してデプロイ

