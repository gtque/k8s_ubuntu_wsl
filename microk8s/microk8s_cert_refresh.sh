#!/bin/bash
sudo microk8s refresh-certs -e server.crt
sudo microk8s refresh-certs -e front-proxy-client.crt
sudo snap restart microk8s
echo "please wait for microk8s to restart."