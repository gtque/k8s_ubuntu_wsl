#!/bin/bash
echo "microk8s config > ~/.kube/config" >> ~/.bashrc
#have to make the dir: /var/snap/microk8s/common/var/lib/kubelet/
sudo ln -s ~/.docker/config.json /var/snap/microk8s/common/var/lib/kubelet/
echo "close the session and start a new one"
#restart the computer on mac.