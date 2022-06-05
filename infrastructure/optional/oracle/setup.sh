#!/bin/bash
echo "deploying oracle"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/oracle/
echo "wait for the pod(s) to finish starting up and then run /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/oracle/init.sh"