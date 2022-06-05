#!/bin/bash
sudo apt-get update
sudo apt update
sudo apt install -y maven
sudo apt install -y git
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt install -y net-tools
sudo apt install -y ansible
ansible --version
ansible localhost -m ping
sudo apt install -y jq
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install -y yq
sudo apt install -y libjson-xs-perl
sudo apt install -y libxml-compile-perl
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
#/usr/local/bin/k8s_ubuntu_wsl/aws/aws_credhelper.sh
#microk8s config can't use the aws cred helper apparently so for now it we still have to use
#docker login, edit the file below and then it.
#/usr/local/bin/k8s_ubuntu_wsl/aws/aws_ecr_login.sh
echo "finished, you can continue to the next step after closing and restarting wsl (powershel -> wsl --shutdown), which should be the docker setup"