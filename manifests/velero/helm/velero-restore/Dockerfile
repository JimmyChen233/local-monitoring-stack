FROM alpine/k8s:1.27.8

RUN apk add --update --no-cache vim

RUN mkdir /root/.kube
ADD temp/kube-config /root/.kube/config

RUN mkdir /root/.aws
ADD temp/aws-config /root/.aws/config
ADD temp/aws-credentials /root/.aws/credentials

RUN mkdir /certs
ADD files/restore-certs.yaml /certs/restore-certs.yaml
RUN mkdir /configmaps
ADD files/restore-configmaps.yaml /configmaps/restore-configmaps.yaml
RUN mkdir /kafkaclusters
ADD files/restore-kafkaclusters.yaml /kafkaclusters/restore-kafkaclusters.yaml
RUN mkdir /namespaces
ADD files/restore-namespaces.yaml /namespaces/restore-namespaces.yaml
RUN mkdir /pvc
ADD files/restore-pvc.yaml /pvc/restore-pvc.yaml
RUN mkdir /secrets
ADD files/restore-secrets.yaml /secrets/restore-secrets.yaml

RUN mkdir /apps/files
