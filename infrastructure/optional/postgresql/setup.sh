#!/bin/bash
echo "deploying postgresql"
kubectl --v=0 apply -f /usr/local/bin/wsl-local-k8s/infrastructure/optional/postgresql/k8s
