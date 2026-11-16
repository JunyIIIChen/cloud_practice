module "app" {
  source = "../../modules/region"

  project_name  = var.project_name
  env           = var.env
  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  desired_count = 1
}

# 读取 mel 环境的 state，拿到备份桶的 ARN
# 所以必须先 apply mel，再 apply syd
data "terraform_remote_state" "mel" {
  backend = "local"
  config = {
    path = "${path.module}/../mel/terraform.tfstate"
  }
}
