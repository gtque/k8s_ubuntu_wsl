#!/bin/bash
echo "deploying postgresql"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/postgresql/k8s
echo "admin(postgres) password: ch@ngm3"
echo "you should probably also deploy pgadmin since the postgresql instance isn't exposed externally"
echo "run: /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/postgresql/pgadmin/setup.sh"