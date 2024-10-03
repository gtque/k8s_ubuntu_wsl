#!/bin/bash
export wsl_configured=$(cat ~/.bashrc | grep "microk8s config")
if [[ -n $microk8s_configured ]]; then
  echo "microk8s looks to be configured"
  exit 0
fi
sudo cp /usr/local/bin/k8s_ubuntu_wsl/wsl/wsl.conf /etc/.
sudo sed -i "s/{USER}/$USER/" /etc/wsl.conf
echo "close the session and either restart wsl by opening a power shell and running 'wsl --shutdown' or by restarting windows"