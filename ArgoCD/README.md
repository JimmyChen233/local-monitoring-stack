# ArgoCD --- GitOps tool for K8S

## login argocd cli
```
argocd login localhost:8080 \
  --insecure \
  --username admin \
  --password $(kubectl get secret \
  -n argocd \
  argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" |
  base64 -d)
  ```