output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "ecr_repo_url" {
  value = module.app.ecr_repo_url
}

output "alb_dns_name" {
  value = module.app.alb_dns_name
}
