variable "deploy_cert_manager" {
  description = "Enable deployment of cert-manager"
  type        = bool
  default     = false
}

variable "deploy_zookeeper" {
  description = "Enable deployment of Zookeeper"
  type        = bool
  default     = false
}

variable "deploy_koperator" {
  description = "Enable deployment of Kafka operator"
  type        = bool
  default     = false
}

variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
  default     = ""
}
