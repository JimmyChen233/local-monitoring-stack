resource "kubectl_manifest" "kafka_namespace" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: kafka
EOF
}

resource "kubectl_manifest" "argocd_kafka_project" {
  yaml_body = file("${path.module}/../../ArgoCD/projects/kafka-project.yaml")
  depends_on = [kubectl_manifest.kafka_namespace]
}

resource "kubectl_manifest" "argocd_kafka_operator_application" {
  yaml_body = file("${path.module}/../../ArgoCD/applications/koperator-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_kafka_project,
    kubectl_manifest.kafka_namespace
  ]
}

resource "kubectl_manifest" "argocd_zookeeper_application" {
  yaml_body = file("${path.module}/../../ArgoCD/applications/zookeeper-application.yaml")
  depends_on = [
    kubectl_manifest.argocd_kafka_project, 
    kubectl_manifest.kafka_namespace
  ]
}
