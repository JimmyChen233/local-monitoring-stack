
# Local Kubernetes Development Cluster

# Overview

This project aims to set up Kubernetes development clusters that serves as a playground for developers. The goal is to provide a platform where team members can add, experiment with, and explore new features and functionalities easily.


## ArgoCD
GitOps approach to deploy applications on the cluster

## Terraform
this folder holds terraform code for clusters

### aws-eks
An aws eks cluster which contains 4 nodes by default.
### kind
A basic k8s cluster running locally with kind, with a control-plane and 2 worker nodes


## Preparations

### Install toolings to your pc
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

5. aws cli
```
brew install awscli

aws configure
```

http://a9d310b9d98dd4efeac6f783173f3c22-1606785509.ap-southeast-2.elb.amazonaws.com/graph?g0.expr=1%20-%20(count_over_time(((time()%20-%20aws_s3_backupmetrics_last_backup_time_maximum%7Bdimension_BucketName%3D%22dprsbackuptest%22%7D)%2F60%20%3E%206.5)%5B1h%3A%5D))%2F%20%0Acount_over_time((aws_s3_backupmetrics_last_backup_time_maximum%7Bdimension_BucketName%3D%22dprsbackuptest%22%7D)%5B1h%3A%5D)%20OR%20on()%20vector(1)&g0.tab=0&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=6h