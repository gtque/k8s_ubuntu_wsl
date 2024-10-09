#!/bin/bash
sudo snap install microk8s --classic --channel=latest/stable
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
echo "exit the session and start a new one"