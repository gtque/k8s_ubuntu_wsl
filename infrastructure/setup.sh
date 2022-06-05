#!/bin/bash
/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/setup.sh
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/k8s


