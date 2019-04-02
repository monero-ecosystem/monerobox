#!/bin/bash

# read service.json
tor=$(jq '.monero.tor' /settings/service.json)

if [ "$tor" = "true" ]; then
  echo "monerod will use tor."

  sleep 10;
  tor_ip=$(getent hosts tor | awk '{ print $1 }'

  if [ -z "$tor_ip" ]; then
    echo "ERROR: Unable to find IP of tor service!";
    exit 1;
  fi

  sed -i "s/TorAddress 127.0.0.1/TorAddress $tor_ip/g" /etc/tor/torsocks.conf

  export TORSOCKS_ALLOW_INBOUND=1
  export DNS_PUBLIC=tcp

  exec torsocks $@
else
  echo "monerod will NOT use tor."

  exec $@
fi


