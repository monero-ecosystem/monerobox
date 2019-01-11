#!/bin/bash
# (c) 2013-2017 - Xavier Berger - http://rpi-experiences.blogspot.fr/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
RPIMONITOR_REPO=../RPi-Monitor-Monerobox
DPKGSRC=$(pwd)/dpkg-src/
RPIMONITOR_SRC=source
VERSION=$(cat ../RPi-Monitor-Monerobox/VERSION)
REVISION=$(cat ../RPi-Monitor-Monerobox/REVISION)

# Remove old package directory
sudo rm -fr ${DPKGSRC}
mkdir ${DPKGSRC}

sudo rm -fr ${RPIMONITOR_SRC}
mkdir -p ${RPIMONITOR_SRC}

echo
echo -e "\033[1mConstructing debian package structure\033[0m"
pushd ${DPKGSRC} > /dev/null
  cp -a ../debian DEBIAN
  sed -i "s/{DATE}/$(LANG=EN; date)/" DEBIAN/changelog
  sed -i "s/{VERSION}/${VERSION}/"    DEBIAN/changelog
  sed -i "s/{REVISION}/${REVISION}/"  DEBIAN/changelog
popd > /dev/null

# Copy from sources
echo
echo -e "\033[1mGetting RPi-Monitor from sources\033[0m"
cp -a ${RPIMONITOR_REPO}/* ${RPIMONITOR_SRC}/
pushd ${RPIMONITOR_SRC} > /dev/null
  export TARGETDIR=${DPKGSRC}
  make install
popd > /dev/null

echo
echo -e "\033[1mSetting version to ${VERSION}-${REVISION}\033[0m"

# Defining version
pushd ${DPKGSRC} > /dev/null
  sed -i "s/{DEVELOPMENT}/${VERSION}-${REVISION}/" DEBIAN/control
  sed -i "s/{DEVELOPMENT}/${VERSION}-${REVISION}/" usr/bin/rpimonitord
  sed -i "s/{DEVELOPMENT}/${VERSION}-${REVISION}/" usr/share/rpimonitor/web/js/rpimonitor.js
  find etc/rpimonitor/ -type f | sed  's/etc/\/etc/' > DEBIAN/conffiles
popd > /dev/null

# Building deb package
echo
echo -e "\033[1mBuilding package\033[0m"
pushd ${DPKGSRC} > /dev/null
  find . -type f ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
  sudo chown -R root:root etc usr
popd > /dev/null
dpkg -b ${DPKGSRC} rpimonitor-monerobox_${VERSION}-${REVISION}_all.deb > /dev/null

# clean up package directory
sudo rm -fr ${DPKGSRC}
sudo rm -fr ${RPIMONITOR_SRC}
