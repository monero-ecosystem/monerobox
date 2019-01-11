#!/bin/bash

# This script downloads monero cli tools from Monero official website and make a deb package from the tarball.

REVISION="monerobox-1"

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

rm -rf build
mkdir build

wget -q -O - $URL | tar -C build -jx

VERSION="$(ls build | tr -d "monero\-v")"

mv build/monero-v$VERSION/* build/

sed s/^Version.*/Version:\ $VERSION-$REVISION/g package.template > build/package.cfg

cp license build/
cp monerod.conf build/
cp monerod.service build/
cp check_monerod_stuck build/
cp check_monerod_stuck_cron build/
cp monero-cli.postinst build/
cp monero-cli.prerm build/

cd build

equivs-build -a $ARCH package.cfg

mv monero-cli*.deb ../

cd ../

rm -rf build
