#!/bin/bash
sudo snap install microk8s --classic --channel=1.24/stable
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
echo "exit the session and start a new one"