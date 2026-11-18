# S3 跨区域复制：syd 桶 -> mel 桶（单向，所以只放在 syd 环境里）

locals {
  # mel 的桶在另一个 state 里，按 module 里的命名规则拼出 ARN
  dr_bucket_arn = "arn:aws:s3:::${var.project_name}-${var.dr_region}-doctor-acknowledgement-bucket"
}

# 让 S3 服务扮演这个 role 去执行复制
resource "aws_iam_role" "s3_replication" {
  name = "${var.project_name}-${var.env}-s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
    }]
  })
}

# 复制需要的最小权限
resource "aws_iam_role_policy" "s3_replication" {
  name = "s3-replication"
  role = aws_iam_role.s3_replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # 读源桶的复制配置、列出对象
        Effect   = "Allow"
        Action   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
        Resource = module.app.ack_bucket_arn
      },
      {
        # 读源桶里对象的各个版本
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Resource = "${module.app.ack_bucket_arn}/*"
      },
      {
        # 把对象写进目标桶
        Effect   = "Allow"
        Action   = ["s3:ReplicateObject", "s3:ReplicateDelete", "s3:ReplicateTags"]
        Resource = "${local.dr_bucket_arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "ack" {
  bucket = module.app.ack_bucket_id
  role   = aws_iam_role.s3_replication.arn

  rule {
    id     = "replicate-to-mel"
    status = "Enabled"

    filter {} # 空 filter = 复制整个桶

    # syd 里的删除不同步到 mel，这样 mel 才是真正的备份
    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = local.dr_bucket_arn
      # storage_class = "STANDARD_IA" # 备份很少读，用低频访问更便宜
    }
  }
}
