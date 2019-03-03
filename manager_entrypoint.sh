#!/bin/bash

set -ex

cd /usr/src/app/docker

# pull yml files and config files from github
git pull
cp settings/* /settings

if [ ! -f "/settings/monerod.conf" ]; then
  # link the monerod config file according to memory of the board
  # For device with 1GB RAM: limit speed avoid oom-killer
  memLimit_1gb="1508344"
  memLimit_2gb="3016688"
  memTotal=`grep MemTotal /proc/meminfo | awk '{print $2}'`
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
  cp settings/* /settings

  # pull images from dockerhub
  /usr/local/bin/docker-compose -f /settings/tor.yml pull
  /usr/local/bin/docker-compose -f /settings/monerod.yml pull
  /usr/local/bin/docker-compose -f /settings/web.yml pull
  /usr/local/bin/docker-compose -f /settings/manager.yml pull
  
  # start all services
  /usr/local/bin/docker-compose -f /settings/tor.yml up -d
  /usr/local/bin/docker-compose -f /settings/monerod.yml up -d
  /usr/local/bin/docker-compose -f /settings/web.yml up -d
  /usr/local/bin/docker-compose -f /settings/manager.yml up -d

  # sleep for 12 hours
  sleep 12h
done
