# S3バケット作成
resource "aws_s3_bucket" "static_site" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "static_site_acl" {
  bucket = aws_s3_bucket.static_site.id
  acl    = "private"
}

locals {
  s3_origin_id = "s3-origin"
}

# CloudFront OAC の作成
resource "aws_cloudfront_origin_access_control" "oac" {
    name                              = "s3-oac"
    description                       = "OAC for CloudFront to access S3"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

# CloudFront ディストリビューション
resource "aws_cloudfront_distribution" "cdn" {
    enabled = true
    default_root_object = "index.html"
    origin {
        domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
        origin_id = local.s3_origin_id
        origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    }

    default_cache_behavior {
        allowed_methods        = ["GET", "HEAD"]
        cached_methods         = ["GET", "HEAD"]
        target_origin_id       = local.s3_origin_id
        viewer_protocol_policy = "redirect-to-https"
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    depends_on = [aws_s3_bucket.static_site]

    tags = {
        Environment = var.environment
    }
}

# S3バケットポリシー（OAC用）
resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.static_site.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}