locals {
  k8s_config_path = pathexpand("./kind-kube-config.yaml")
  repos_yaml_files = fileset("${path.module}/repos/", "*.yaml")
}
