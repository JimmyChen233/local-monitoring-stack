resource "kubectl_manifest" "argocd_namespace" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: argocd
EOF
}

resource "helm_release" "argo" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd" 
  namespace  = "argocd" 
  version    = "7.1.3"

# An option for setting values that I generally use
#   values = [jsonencode({
#     someKey = "someValue"
#   })]
}