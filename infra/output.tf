output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}