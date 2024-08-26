# deploy new argo applications
1. add a terraform argocd application block in /Terraform/argo-project/default-project.tf, and "deploy_*" variable
2. add an *-application.yaml file in /ArgoCD/applications. If the helm chart is from another repo, make sure that repo url is configured as sourceRep in /ArgoCD/projects/default-project.yaml. If custom helm values is needed, add a folder under /ArgoCD/apps
3. terraform apply

## Destroy (Optional)
delete an application
```
kubectl -n argocd delete application *
```

destroy whole cluster
```
terraform destroy
```

## ArgoCD
default user is admin
# get argocd pw
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
