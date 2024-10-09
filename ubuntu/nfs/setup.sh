#!/bin/bash

nfsdir=${nfsdir:-nfs}

sudo apt install -y nfs-kernel-server
sudo apt-get install -y nfs-common
if [ $# -gt 0 ]; then
  echo "At least one parameter was provided."
  while [ $# -gt 0 ]; do
    declare nfsdir="$1"
    shift
    echo "creating '$nfsdir' directory."
    sudo mkdir /$nfsdir
    sudo chmod 777 /$nfsdir
    echo "/$nfsdir *(rw,async,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
  done
else
  echo "No parameters were provided, creating default '$nfsdir' directory."
  sudo mkdir /$nfsdir
  sudo chmod 777 /$nfsdir
  echo "/$nfsdir *(rw,async,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
fi


sudo exportfs -ra
sudo systemctl start nfs-kernel-server.service
#/usr/local/bin/k8s_ubuntu_wsl/nfs/nfs_client.sh
#sudo service nfs-kernel-server restart