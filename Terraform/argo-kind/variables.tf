variable "deploy_traefik" {
  description = "Enable deployment of traefik"
  type        = bool
  default     = false
}

variable "deploy_external_dns" {
  description = "Enable deployment of external_dns"
  type        = bool
  default     = false
}

variable "deploy_telegraf" {
  description = "Enable deployment of telegraf"
  type        = bool
  default     = false
}

variable "deploy_grafana_mimir" {
  description = "Enable deployment of grafana_mimir"
  type        = bool
  default     = false
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

variable "deploy_script_exporter" {
  description = "Enable deployment of script-exporter"
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

variable "deploy_jenkins" {
  description = "Enable deployment of Jenkins"
  type        = bool
  default     = true
}

variable "deploy_dprs_poc" {
  description = "Enable deployment of dprs_poc"
  type        = bool
  default     = false
}

variable "deploy_kube2iam" {
  description = "Enable deployment of kube2iam"
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

variable "deploy_aws_load_balancer_controller" {
  description = "Enable deployment of aws_load_balancer_controller"
  type        = bool
  default     = false
}