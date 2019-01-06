#!/bin/bash

if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root or with sudo"
  exit
fi

# add new user "rock64" with password "rock64" to sudo group, ayufan's image already has user "rock64" in sudo group
#adduser --gecos "" rock64
#echo "rock64:rock64" | chpasswd
#usermod -aG sudo rock64

# create mount point for SSD
mkdir /mnt/data
chown rock64:rock64 /mnt/data

# blacklist UAS
echo "options usb-storage quirks=0x2537:0x1066:u,0x2537:0x1068:u,0x0bc2:0xa013:u,0x152d:0x0578:u,0x0bc2:0x2101:u,0x2109:0x0715:u" > /etc/modprobe.d/blacklist-uas.conf
update-initramfs -u

# mount ssd at boot
echo "/dev/sda1 /mnt/data ext4 defaults 0 0" >> /etc/fstab
mount -a

# sudoer file for rock64
echo "Cmnd_Alias SYSTEMCTL_MONEROD = /bin/systemctl start monerod, /bin/systemctl stop monerod, /bin/systemctl restart monerod, /bin/systemctl enable monerod, /bin/systemctl disable monerod, /usr/sbin/service rpimonitor restart, /sbin/shutdown -h now, /sbin/shutdown -r now" >> /etc/sudoers.d/rock64
echo "%rock64 ALL=(ALL) NOPASSWD: SYSTEMCTL_MONEROD" >> /etc/sudoers.d/rock64

# add monerobox repo to apt
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2895E20A
echo "deb http://apt-repo.hcwong.me/ bionic main" | tee --append /etc/apt/sources.list.d/monerobox.list

# update apt repo
apt update
apt upgrade -y

# setup apt unattened update for monerobox repo
apt install -y unattended-upgrades
echo "Unattended-Upgrade::Origins-Pattern { \"o=monerobox,n=bionic,l=monerobox,c=main\"; }; " >> /etc/apt/apt.conf.d/50unattended-upgrades


# setup zero-conf network
echo "monerobox" > /etc/hostname
apt install -y avahi-daemon

# install monero-cli, rpimonitor and shellinabox
apt install -y monero-cli rpimonitor shellinabox

# add cronjob to check if monerod is stuck
echo "*/10    *       *       *       *       root    /usr/bin/check_monerod_stuck >> /var/log/check_monerod_stuck.log 2>&1" >> /etc/crontab

