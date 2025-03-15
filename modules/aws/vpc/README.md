# 📂 terraform-aws-infra/
# │── modules/aws/vpc/
# │   ├── main.tf         # VPC, サブネット, IGW, NAT の定義
# │   ├── variables.tf    # モジュールの変数
# │
# │── envs/dev/
# │   ├── main.tf         # VPCモジュールを呼び出す
# │   ├── variables.tf    # 変数定義（modules/aws/vpc/ と同じ）
# │   ├── terraform.tfvars # 変数の具体的な値
# │   ├── provider.tf     # AWSプロバイダー設定（環境ごとに作成）

# cd envs/dev  # Dev環境のディレクトリへ移動
# 
# terraform init  # 初期化（プロバイダーやモジュールを読み込む）
# 
# terraform plan  # どのリソースが作成されるか確認
# 
# terraform apply -auto-approve  # 実際にAWSへリソースを作成