#!/bin/bash

# This script downloads monero cli tools from Monero official website and make a deb package from the tarball.

if [ "$1" = "armv7" ]; then
  echo "Building package for armv7"
  URL="https://downloads.getmonero.org/cli/linuxarm7"
  ARCH="armhf"
elif [ "$1" = "armv8" ]; then
  echo "Building package for armv8"
  URL="https://downloads.getmonero.org/cli/linuxarm8"
  ARCH="arm64"
else
  echo "Usage: ./build.sh [armv7 | armv8]"
  exit 1
fi

rm -rf monero_binary package.cfg
mkdir monero_binary

wget -q -O - $URL | tar -C monero_binary -jx

VERSION="$(ls monero_binary | tr -d "monero\-v")"

mv monero_binary/monero-v$VERSION/* monero_binary/

sed s/^Version.*/Version:\ $VERSION/g package.template > package.cfg

equivs-build -a $ARCH package.cfg

rm -rf monero_binary package.cfg
