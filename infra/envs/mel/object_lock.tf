# 备份桶的 Object Lock（WORM：写入后在保留期内不能删除/覆盖）
# 只有 mel 备份桶需要，所以放在 mel 环境里，不放进 module
#
# 前提：桶已开启版本控制（module 里已经开了）
# 注意：Object Lock 一旦开启就无法关闭
resource "aws_s3_bucket_object_lock_configuration" "ack_backup" {
  bucket = module.app.ack_bucket_id

  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      # GOVERNANCE：有 s3:BypassGovernanceRetention 权限的人可以提前删除（练习用这个）
      # COMPLIANCE：任何人（包括 root）都不能删除，也不能缩短保留期
      mode = "GOVERNANCE"
      days = 1
    }
  }
}
