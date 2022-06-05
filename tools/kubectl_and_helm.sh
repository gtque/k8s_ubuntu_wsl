#!/bin/bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
echo "installing helm v2 as helm2"
curl "https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz" -o "helm.tar.gz"
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm2
sudo mv linux-amd64/tiller /usr/local/bin/
helm2 init
rm helm.tar.gz
echo "installing helm v3 as helm"
curl "https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz" -o "helm.tar.gz"
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm helm.tar.gz