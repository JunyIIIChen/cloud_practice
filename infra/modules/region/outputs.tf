output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.ecr_repo.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "bucket_id" {
  value = aws_s3_bucket.data.id
}

output "bucket_arn" {
  value = aws_s3_bucket.data.arn
}

output "bucket_versioning_id" {
  description = "用于让复制配置依赖于版本控制已开启"
  value       = aws_s3_bucket_versioning.data.id
}
