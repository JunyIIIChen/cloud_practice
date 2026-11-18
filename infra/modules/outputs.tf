output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.ecr_repo.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ack_bucket_id" {
  # 从 versioning 资源取，保证复制配置在版本控制开启之后才创建
  value = aws_s3_bucket_versioning.acknowledgement.bucket
}

output "ack_bucket_arn" {
  value = aws_s3_bucket.acknowledgement.arn
}
