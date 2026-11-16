variable "env" {
  type    = string
  default = "mel"
}

variable "aws_region" {
  description = "DR 站点区域（墨尔本）。注意 ap-southeast-4 是 opt-in 区域，需要先在账号里启用"
  type        = string
  default     = "ap-southeast-4"
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

variable "vpc_cidr" {
  description = "VPC 的 CIDR 块（和 syd 的 10.0.0.0/16 错开）"
  type        = string
  default     = "10.1.0.0/16"
}

variable "desired_count" {
  description = "平时为 0（pilot light：基础设施在，但不跑任务）。演练 failover 时改成 1"
  type        = number
  default     = 0
}
