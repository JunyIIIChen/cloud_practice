variable "project_name" {
  description = "项目名，用于资源命名"
  type        = string
}

variable "env" {
  description = "环境名（syd / mel），拼进资源名，避免两套环境的全局资源（IAM role 等）重名"
  type        = string
}

variable "aws_region" {
  description = "该环境所在的 AWS 区域，用于 AZ 和日志配置"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC 的 CIDR 块（两个区域用不同网段，方便以后做 peering）"
  type        = string
}

variable "desired_count" {
  description = "ECS 任务数。DR 站点可以设为 0（pilot light），failover 时再调大"
  type        = number
  default     = 1
}
