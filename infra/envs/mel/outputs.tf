# syd 环境通过 terraform_remote_state 读取这些 output
output "bucket_id" {
  value = module.app.bucket_id
}

output "bucket_arn" {
  value = module.app.bucket_arn
}

output "ecr_repo_url" {
  value = module.app.ecr_repo_url
}

output "alb_dns_name" {
  value = module.app.alb_dns_name
}
