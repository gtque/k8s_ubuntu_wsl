#!/bin/bash
echo "deploying postgresql"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/postgresql/pgadmin/k8s
echo "admin(postgres) password: ch@ngm3"
echo "dev password: iliketurtles"