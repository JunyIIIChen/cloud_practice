module "app" {
  source = "../../modules/region"

  project_name  = var.project_name
  env           = var.env
  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  desired_count = 1
}
