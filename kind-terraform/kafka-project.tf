
resource "kubectl_manifest" "argocd_kafka_project" {
  yaml_body = file("${path.module}/../ArgoCD/projects/kafka-project.yaml")
  depends_on = []
}

resource "kubectl_manifest" "argocd_namespaces" {
  yaml_body = file("${path.module}/../ArgoCD/applications/namespace-application.yaml")
  depends_on = []
}

resource "kubectl_manifest" "argocd_crd" {
  yaml_body = file("${path.module}/../ArgoCD/applications/CRD-application.yaml")
  depends_on = []
} 

resource "kubectl_manifest" "argocd_cert_manager_application" {
  count = var.deploy_cert_manager ? 1 : 0
  yaml_body = file("${path.module}/../ArgoCD/applications/cert-manager-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_kafka_project,
    kubectl_manifest.argocd_namespaces,
    kubectl_manifest.argocd_crd
  ]
}

resource "kubectl_manifest" "argocd_zookeeper_application" {
  count = var.deploy_zookeeper ? 1 : 0
  yaml_body = file("${path.module}/../ArgoCD/applications/zookeeper-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_kafka_project,
    kubectl_manifest.argocd_namespaces,
    kubectl_manifest.argocd_crd,
    kubectl_manifest.argocd_cert_manager_application
  ]
}

resource "kubectl_manifest" "argocd_kafka_operator_application" {
  count = var.deploy_koperator ? 1 : 0
  yaml_body = file("${path.module}/../ArgoCD/applications/koperator-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_kafka_project,
    kubectl_manifest.argocd_namespaces,
    kubectl_manifest.argocd_crd,
    kubectl_manifest.argocd_zookeeper_application,
    kubectl_manifest.argocd_cert_manager_application,
  ]
}



