#!/bin/bash
echo "deploying oracle"
kubectl --v=0 apply -f /usr/local/bin/wsl-local-k8s/infrastructure/optional/oracle/
echo "wait for the pod(s) to finish starting up and then run /usr/local/bin/wsl-local-k8s/infrastructure/optional/oracle/init.sh"