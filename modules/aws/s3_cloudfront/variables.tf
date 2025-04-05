variable "bucket_name" {
    description = "S3バケット名"
    type = string
}

variable "environment" {
  description = "環境名（例：dev, prod）"
  type        = string
}