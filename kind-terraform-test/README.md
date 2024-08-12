# Kind --- A Local convenient and free local development cluster

## Preparations

# Install toolings to your pc
Here we use MacBook as an example
make sure you have homebrew :wink:
1. docker
```
brew install docker
# It is not verified yet because I installed it ages ago. Feel free to update
```

2. k8s
```
brew install kubectl
kubectl version --client
```
3. terraform
The `tfswitch` command line tool lets you switch between different versions of terraform
```
brew install warrensbox/tap/tfswitch
tfswitch 1.7.5
```

4. kind
```
brew install kind
```

# Set up Cloud Provider if needed
to be continued...

## Launch the local dev platform

# apply terraform
```
cd clusters/k8s-kind-local
terraform init
terraform apply
```
You should see a kube-config file is generated in this folder. The kube config is also output into ~/.kube/config, but sometimes it messes up once update. So, `export KUBECONFIG='./kind-kube-config.yaml'`
Now check you k8s cluster `kubectl config current-context`

Remeber to set it back `export KUBECONFIG='~/.kube/config'`

# deploy k8s components
to be continued...

## Destroy (Optional)
You don't have to destroy the local platform everyday, because it's cost-free and currently no restore option, which means you will lose all your work and unable to bring back :firecracker:
However, if you really screw it up, want to shup down and restart, you can do:
```
terraform destroy
```

## ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d