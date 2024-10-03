#!/bin/bash
#https://github.com/nginxinc/nginx-kubernetes-gateway/blob/main/docs/installation.md
#currently set to v1.1.0
tag="v1.1.0"
echo "deploying nginx gateway"
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
echo "installing the gateway api resources"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/$tag/standard-install.yaml
echo "deploying the CRDs"
kubectl apply -f deploy/manifests/crds
echo "installing the gateway"
kubectl apply -f deploy/manifests/nginx-gateway.yaml
kubectl get pods -n nginx-gateway
echo "adding a load balancer entry for the gateway"
kubectl apply -f deploy/manifests/service/loadbalancer.yaml
cd ..
rm -rf nginx-kubernetes-gateway