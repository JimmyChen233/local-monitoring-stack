resource "kubectl_manifest" "argocd_namespace" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: argocd
EOF
}

resource "kubectl_manifest" "oci_secret" {
  yaml_body = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: docker-io-helm-oci
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: oci://ghcr.io/grafana/helm-charts
  name: grafana-operator
  type: helm
  enableOCI: "true"
EOF

  depends_on = [
    kubectl_manifest.argocd_namespace
  ]
}

resource "kubectl_manifest" "argocd_private_repo_secret" {
  yaml_body = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/JimmyChen233/local-monitoring-stack.git
  username: "${var.github_username}"
  password: "${var.github_token}"
EOF

  depends_on = [
    kubectl_manifest.argocd_namespace
  ]
}

resource "helm_release" "argo" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.4.3"
  depends_on = [kubectl_manifest.argocd_namespace, kubectl_manifest.oci_secret, kubectl_manifest.argocd_private_repo_secret]
}

