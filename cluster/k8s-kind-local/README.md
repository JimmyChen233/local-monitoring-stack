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

# Set up Cloud Provider if needed
to be continued...

## Launch the local dev platform

# apply terraform
```
cd cluster/k8s-kind-local
terraform init
terraform apply
```
You should see a kube-config file is generated in this folder. The kube config is also output into ~/.kube/config. Now check you k8s cluster `kubectl config current-context`

# deploy k8s components
to be continued...

