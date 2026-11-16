############ S3 跨区域复制：syd 主桶 -> mel 备份桶 ############

# S3 复制服务代入这个 role，去读源桶、写目标桶
resource "aws_iam_role" "s3_replication" {
  name = "${var.project_name}-${var.env}-s3-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_replication" {
  name = "${var.project_name}-${var.env}-s3-replication"
  role = aws_iam_role.s3_replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
        Resource = module.app.bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Resource = "${module.app.bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Resource = "${data.terraform_remote_state.mel.outputs.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "to_mel" {
  # 必须等源桶的版本控制开启后才能配置复制：
  # 引用 versioning 资源的 id（就是桶名），Terraform 会自动排好顺序
  bucket = module.app.bucket_versioning_id
  role   = aws_iam_role.s3_replication.arn

  rule {
    id     = "replicate-all-to-mel"
    status = "Enabled"

    filter {} # 空 filter = 复制整个桶

    # 删除标记也复制过去（注意：带版本号的永久删除不会被复制，这正是版本控制保护数据的地方）
    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = data.terraform_remote_state.mel.outputs.bucket_arn
      storage_class = "STANDARD_IA" # 备份数据很少读，用 IA 省钱
    }
  }
}

############ ECR 跨区域复制：push 到 syd 的镜像自动同步到 mel ############
# 这样 DR 时 mel 的 ECS 直接就有镜像可用

data "aws_caller_identity" "current" {}

resource "aws_ecr_replication_configuration" "to_mel" {
  replication_configuration {
    rule {
      destination {
        region      = var.dr_region
        registry_id = data.aws_caller_identity.current.account_id
      }
    }
  }
}
