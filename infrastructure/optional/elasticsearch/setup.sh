#!/bin/bash
echo "deploying elasticsearch"
kubectl --v=0 apply -f /usr/local/bin/wsl-local-k8s/infrastructure/optional/elasticsearch/k8s
