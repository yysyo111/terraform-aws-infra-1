variable "environment" {
  description = "環境名（例: dev, prod）"
  type        = string
}

variable "repository" {
  description = "GitHub リポジトリ（例: username/repo）"
  type        = string
}

variable "bucket_name" {
  description = "アップロード先のS3バケット名"
  type        = string
}