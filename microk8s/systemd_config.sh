#!/bin/bash
sudo cp /usr/local/bin/k8s_ubuntu_wsl/microk8s/wsl.conf /etc/.
sudo sed -i "s/{USER}/$USER/" /etc/wsl.conf
sudo cp /usr/local/bin/k8s_ubuntu_wsl/microk8s/00-wsl2-systemd.sh /etc/profile.d/.
echo "close the session and either restart wsl by opening a power shell and running 'wsl --shutdown' or by restarting windows"