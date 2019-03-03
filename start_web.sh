#/bin/bash

export HOST_HOSTNAME=$(hostname)
export HOST_IP=$(ip -4 addr show eth0 | grep -Po 'inet \K[\d.]+')

docker-compose -f settings/web.yml up -d

