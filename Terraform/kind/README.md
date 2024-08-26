## Launch the local dev platform

# apply terraform kind
before apply, you need tocreate a terraform.tfvars file and enable to applications you want to deploy --> see variables.tf
example file:
![alt text](image.png)
```
cd clusters/k8s-kind-local
terraform init
terraform apply
```
You should see a kube-config file is generated in this folder. The kube config is also output into ~/.kube/config, but sometimes it messes up once update. So, 
```
export KUBECONFIG="/Users/$(whoami)/YourWorkDir/local-monitoring-stack/kind-terraform/kind-kube-config.yaml"
```
Now check you k8s cluster `kubectl config current-context`

Remeber to set it back `export KUBECONFIG='~/.kube/config'`