variable "deploy_cert_manager" {
  description = "Enable deployment of cert-manager"
  type        = bool
  default     = true
}

variable "deploy_zookeeper" {
  description = "Enable deployment of Zookeeper"
  type        = bool
  default     = true
}

variable "deploy_koperator" {
  description = "Enable deployment of Kafka operator"
  type        = bool
  default     = true
}
