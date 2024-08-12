
resource "kubectl_manifest" "argocd_default_project" {
  yaml_body = file("${path.module}/../ArgoCD/projects/default-project.yaml")
  depends_on = []
}

resource "kubectl_manifest" "argocd_namespaces" {
  yaml_body = file("${path.module}/../ArgoCD/applications/namespace-application.yaml")
  depends_on = []
}

resource "kubectl_manifest" "argocd_crd" {
  yaml_body = file("${path.module}/../ArgoCD/applications/crd-application.yaml")
  depends_on = []
} 

resource "kubectl_manifest" "argocd_prometheus_application" {
  count = var.deploy_cert_manager ? 1 : 0
  yaml_body = file("${path.module}/../ArgoCD/applications/prometheus-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_default_project,
    kubectl_manifest.argocd_namespaces,
    kubectl_manifest.argocd_crd
  ]
}





