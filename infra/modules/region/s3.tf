data "aws_caller_identity" "current" {}

# 每个区域一个数据桶：syd 是主桶，mel 是 DR 备份桶（复制目标）
# 桶名全局唯一，所以拼上账号 ID
resource "aws_s3_bucket" "data" {
  bucket        = "${local.name}-data-${data.aws_caller_identity.current.account_id}"
  force_destroy = true # 练习环境，方便 destroy
}

# 跨区域复制要求源桶和目标桶都开启版本控制
resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
