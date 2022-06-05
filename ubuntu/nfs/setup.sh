#!/bin/bash
sudo apt install -y nfs-kernel-server
sudo apt-get install -y nfs-common
sudo mkdir /ftp
sudo chmod 777 /ftp
echo '/ftp *(rw,async,no_subtree_check,no_root_squash)' | sudo tee -a /etc/exports
sudo exportfs -ra
sudo systemctl start nfs-kernel-server.service
/usr/local/bin/k8s_ubuntu_wsl/nfs/nfs_client.sh
#sudo service nfs-kernel-server restart