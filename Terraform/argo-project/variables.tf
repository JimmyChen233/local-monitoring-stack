variable "region" {
  type        = string
  default     = "ap-southeast-2"
  description = "region"
}

variable "aws_profile" {
  type        = string
  default     = ""
  description = "aws profile"
}

variable "cluster_type" {
  description = "The target Kubernetes cluster type is eks/kind"
  type        = string
  default     = "kind"
}

variable "deploy_prometheus_operator" {
  description = "Enable deployment of prometheus-operator"
  type        = bool
  default     = false
}

variable "deploy_grafana_operator" {
  description = "Enable deployment of grafana-operator"
  type        = bool
  default     = false
}

variable "deploy_blackbox_exporter" {
  description = "Enable deployment of blackbox-exporter"
  type        = bool
  default     = false
}

variable "deploy_cloudwatch_exporter" {
  description = "Enable deployment of cloudwatch-exporter"
  type        = bool
  default     = false
}

variable "deploy_sloth" {
  description = "Enable deployment of sloth SLO"
  type        = bool
  default     = false
}

variable "github_repository_url" {
  description = "GitHub repository url"
  type        = string
  default     = ""
}

variable "github_username" {
  description = "GitHub username"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
  default     = ""
}
