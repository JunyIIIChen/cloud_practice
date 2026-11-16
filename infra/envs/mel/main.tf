# DR 站点：和 syd 同一套 module，桶作为 syd 主桶的复制目标（备份桶）
module "app" {
  source = "../../modules/region"

  project_name  = var.project_name
  env           = var.env
  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  desired_count = var.desired_count
}
