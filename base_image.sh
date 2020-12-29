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

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

# install docker-compose
sudo apt-get install -y libffi-dev libssl-dev
sudo apt-get install -y python3 python3-pip
sudo apt-get remove -y python-configparser

sudo pip3 -v install docker-compose

# add user pi to docker group
usermod -aG docker pi

# reboot
echo "System will reboot it 10 seconds."
sleep 10
reboot

