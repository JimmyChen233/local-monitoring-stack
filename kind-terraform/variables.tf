variable "deploy_prometheus_operator" {
  description = "Enable deployment of prometheus-operator"
  type        = bool
  default     = true
}

variable "deploy_grafana_operator" {
  description = "Enable deployment of grafana-operator"
  type        = bool
  default     = true
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
