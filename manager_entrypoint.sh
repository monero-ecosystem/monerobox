#!/bin/bash

set -ex

memLimit_1gb="1508344"
memLimit_2gb="3016688"
memTotal=`grep MemTotal /proc/meminfo | awk '{print $2}'`

cd /usr/src/app/monerobox

# get new yml and config files
git pull
cp settings/*.yml /settings
cp settings/monerod.conf.* /settings/
cp settings/*.conf /settings/

# copy service config file only if it does not exist
if [ ! -f "/settings/service.json" ]; then
  cp settings/service.json /settings/
fi

# link the monerod config file according to memory of the board, only if it does not exist
if [ ! -f "/settings/monerod.conf" ]; then
  # For device with 1GB RAM: limit speed avoid oom-killer
  if [ "$memTotal" -lt "$memLimit_1gb" ]; then
    ln -s /settings/monerod.conf.1gb /settings/monerod.conf
  elif [ "$memTotal" -lt "$memLimit_2gb" ]; then
    ln -s /settings/monerod.conf.2gb /settings/monerod.conf
  else
    ln -s /settings/monerod.conf.4gb /settings/monerod.conf
  fi
fi

while :
do
  # get new yml and config files
  git pull
  cp settings/*.yml /settings/

  # pull docker images
  /usr/local/bin/docker-compose -f /settings/tor.yml pull
  /usr/local/bin/docker-compose -f /settings/monerod.yml pull
  /usr/local/bin/docker-compose -f /settings/web.yml pull
  /usr/local/bin/docker-compose -f /settings/manager.yml pull

  # start enabled services 
  /usr/local/bin/docker-compose -f /settings/tor.yml up -d
  /usr/local/bin/docker-compose -f /settings/monerod.yml up -d
  /usr/local/bin/docker-compose -f /settings/web.yml up -d
  # /usr/local/bin/docker-compose -f /settings/manager.yml up -d

  # sleep for 12 hours
  sleep 12h
done

