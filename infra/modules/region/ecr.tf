resource "aws_ecr_repository" "ecr_repo" {
  # 名字不带 env：ECR 复制会写入目标区域的同名仓库
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}