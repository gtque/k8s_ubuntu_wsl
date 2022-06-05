#!/bin/bash
echo "deploying postgresql"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/postgresql/k8s
