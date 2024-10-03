#!/bin/bash
export microk8s_configured=$(cat ~/.bashrc | grep "microk8s config")
if [[ -n $microk8s_configured ]]; then
  echo "microk8s looks to be configured"
  exit 0
fi
echo "microk8s auto config will be added."
#echo "microk8s config > ~/.kube/config" >> ~/.bashrc
#have to make the dir: /var/snap/microk8s/common/var/lib/kubelet/
#sudo ln -s ~/.docker/config.json /var/snap/microk8s/common/var/lib/kubelet/
#echo "close the session and start a new one"
#restart the computer on mac.