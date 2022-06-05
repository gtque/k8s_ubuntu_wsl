#!/bin/bash
echo "deploying elasticsearch"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/elasticsearch/k8s
