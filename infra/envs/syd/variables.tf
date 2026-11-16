variable "env" {
  type    = string
  default = "syd"
}

variable "aws_region" {
  description = "主站点区域（悉尼）"
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
  default     = "JunyIIIChen@131532515/cloud_practice@1441472852"
}

variable "vpc_cidr" {
  description = "VPC 的 CIDR 块"
  type        = string
  default     = "10.0.0.0/16"
}
