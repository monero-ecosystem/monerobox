#!/bin/bash

# This script is used to create the OS image for monerobox.
# It requires a clean ayufan's Rock64 Linux releases installed.
# ayufan's Linux can be found at https://github.com/ayufan-rock64/linux-build/releases

if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root or with sudo"
  exit
fi

# add new user "rock64" with password "rock64" to sudo group, ayufan's image already has user "rock64" in sudo group
#adduser --gecos "" rock64
#echo "rock64:rock64" | chpasswd
#usermod -aG sudo rock64

# create data directory for blockchain
mkdir /data
chown rock64:rock64 /data

# blacklist UAS
echo "options usb-storage quirks=0x2537:0x1066:u,0x2537:0x1068:u,0x0bc2:0xa013:u,0x152d:0x0578:u,0x0bc2:0x2101:u,0x2109:0x0715:u" > /etc/modprobe.d/blacklist-uas.conf
update-initramfs -u

# add monerobox repo to apt
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2895E20A
echo "deb http://repo.monerobox.store/ bionic main" | tee --append /etc/apt/sources.list.d/monerobox.list

# update apt repo
apt update
apt upgrade -y

# setup apt unattened update for monerobox repo
apt install -y unattended-upgrades
echo "Unattended-Upgrade::Origins-Pattern { \"o=monerobox,n=bionic,l=monerobox,c=main\"; }; " >> /etc/apt/apt.conf.d/50unattended-upgrades
echo "Dpkg::Options { \"--force-confdef\"; \"--force-confold\"; };" >> /etc/apt/apt.conf.d/50unattended-upgrades


# setup zero-conf network
echo "monerobox" > /etc/hostname
apt install -y avahi-daemon

# install monero-cli, rpimonitor, shellinabox and openvpn
apt install -y monero-cli rpimonitor-monerobox shellinabox openvpn

# For device with 1GB RAM: limit speed and maxcurrency to avoid oom-killer
memLimit="1508344"
memTotal=`grep MemTotal /proc/meminfo | awk '{print $2}'`
if [ "$memTotal" -lt "$memLimit" ]; then
  echo "limit-rate=1000" >> /etc/monerod.conf
  echo "max-concurrency=3" >> /etc/monerod.conf
  systemctl restart monerod
fi

