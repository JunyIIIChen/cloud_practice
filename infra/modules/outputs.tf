output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.ecr_repo.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
