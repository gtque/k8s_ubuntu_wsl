#!/bin/bash
#https://github.com/nginxinc/nginx-kubernetes-gateway/blob/main/docs/installation.md
#currently set to v0.8.0
tag="v1.1.0"
echo "undeploying nginx gateway"
if [ -d "nginx-kubernetes-gateway" ]; then
  echo "nginx-kubernetes-gateway does exist, assuming already cloned."
  cd nginx-kubernetes-gateway
  git pull
  git checkout $tag
else
  echo "nginx-kubernetes-gateway not detected, cloning to here."
  git clone https://github.com/nginxinc/nginx-kubernetes-gateway.git
  cd nginx-kubernetes-gateway
  git checkout $tag
fi
kubectl delete -f deploy/manifests/service/loadbalancer.yaml
kubectl delete -f deploy/manifests/nginx-gateway.yaml
kubectl delete -f deploy/manifests/crds
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/$tag/standard-install.yaml
cd ..
rm -rf nginx-kubernetes-gateway