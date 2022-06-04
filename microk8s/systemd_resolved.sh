#!/bin/bash
sudo sed -i "s/#DNS=/DNS=8.8.8.8/" /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
sudo apt update
echo 'net.ipv4.conf.all.route_localnet = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf