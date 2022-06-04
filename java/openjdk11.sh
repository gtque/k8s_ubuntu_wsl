#!/bin/bash
echo "setting up jdk 11, for jdk 8 you are on your own..."
wget "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz"
tar -zxvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
sudo mkdir /java
sudo mv jdk-11.0.11+9/ /java/.
sudo sh -c "echo 'export JAVA_HOME=/java/jdk-11.0.11+9/' > /etc/profile.d/jdk_home.sh"
rm OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
