#/bin/bash

docker network create monerobox
docker volume create data_monero
docker volume create settings

export HOST_HOSTNAME=$(hostname)
export HOST_IP=$(ip -4 addr show eth0 | grep -Po 'inet \K[\d.]+')

docker-compose -f settings/manager.yml up -d

