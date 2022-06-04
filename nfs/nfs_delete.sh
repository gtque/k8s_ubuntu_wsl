#!/bin/bash
kubectl delete -f /usr/local/bin/wsl-local-k8s/nfs/k8s/01_rbac.yaml
kubectl delete -f /usr/local/bin/wsl-local-k8s/nfs/k8s/02_deployment.yaml
kubectl delete -f /usr/local/bin/wsl-local-k8s/nfs/k8s/03_class.yaml
kubectl delete ns nfs

