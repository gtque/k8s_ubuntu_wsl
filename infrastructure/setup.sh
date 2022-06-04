#!/bin/bash
/usr/local/bin/wsl-local-k8s/infrastructure/certs/setup.sh
kubectl --v=0 apply -f /usr/local/bin/wsl-local-k8s/infrastructure/k8s


