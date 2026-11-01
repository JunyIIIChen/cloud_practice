variable "aws_region" {
  description = "部署资源的 AWS 区域"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_profile" {
  description = "本地 ~/.aws/config 里使用的 profile"
  type        = string
  default     = "personal"
}

variable "project_name" {
  description = "项目名，用于资源命名和 Project 标签"
  type        = string
  default     = "cloud-practice"
}

variable "github_repo" {
  description = "GitHub 仓库名称"
  type        = string
  default     = "cloud_practice"
}
