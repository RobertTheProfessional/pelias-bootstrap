#!/bin/bash

#=============
# Folder setup
#=============
BASE=/mnt
TOOLS=$BASE/pelias/tools
DATA=$BASE/pelias/data

#=======
#cleanup
#=======

rm -r $DATA
rm -r $TOOLS
rm -r $HOME/.pelias
rm -r $HOME/pelias-bootstrap
sudo rm /etc/sudoers.d/pelias-admin-user
apt-get purge -y git unzip python python-pip python-dev build-essential gdal-bin rlwrap golang-go
apt-get clean