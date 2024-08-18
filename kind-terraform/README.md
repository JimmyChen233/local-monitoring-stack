# Kind --- A Local convenient and free local development cluster

## Preparations

# Install toolings to your pc
Here we use MacBook as an example
make sure you have homebrew :wink:
1. docker
```
brew install docker

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
before apply, you need tocreate a terraform.tfvars file and enable to applications you want to deploy --> see variables.tf
```
cd clusters/k8s-kind-local
terraform init
terraform apply
```
You should see a kube-config file is generated in this folder. The kube config is also output into ~/.kube/config, but sometimes it messes up once update. So, 
```
export KUBECONFIG="/Users/$(whoami)/YourWorkDir/k8s-dev-254/kind-terraform/kind-kube-config.yaml"
```
Now check you k8s cluster `kubectl config current-context`

Remeber to set it back `export KUBECONFIG='~/.kube/config'`

# deploy k8s components


## Destroy (Optional)
```
terraform destroy
```

## ArgoCD
default user is admin
# get argocd pw
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
