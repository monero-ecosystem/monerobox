#!/bin/bash

# This script is used to create the base OS image for monerobox.
# It requires a clean  Armbian_5.69_Rock64_Ubuntu_bionic_default_4.4.167 releases installed
# and a user "rock64" with sudo permission

if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root or with sudo"
  exit
fi

# update apt repo
apt update
apt upgrade -y

# setup zero-conf network
echo "monerobox" > /etc/hostname
apt install -y avahi-daemon

# install docker
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update

apt install -y docker-ce docker-ce-cli containerd.io

# install docker-compose
apt install -y python-pip python-setuptools
pip install docker-compose


# add user rock64 to docker group
usermod -aG docker rock64

# reboot
echo "System will reboot it 10 seconds."
sleep 10
reboot

