#!/bin/bash
echo "deploying postgresql"
kubectl --v=0 apply -f /usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/postgresql/pgadmin/k8s
echo "url: pgadmin.local.dev"
echo "you will need to add an entry to your hosts file, the ip address will be the external ip address of the ingress service"
echo "kubectl -n ingress get service"
echo "user email: youremail@domain.com"
echo "password: iliketurtles"
echo "assuming you also deployed postgres, you can use 'postgres' as the hostname for the connection."