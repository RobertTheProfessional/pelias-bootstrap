#!/bin/bash

#=============
# Folder setup
#=============
#BASE=/mnt
#TOOLS=$BASE/pelias/tools
TOOLS=$HOME/.pelias

#if [ -d $TOOLS ]; then
    rm -rf $TOOLS/
#fi

#mkdir -p $TOOLS

#chmod 2775 $TOOLS

#=========================================
# Install importers and their dependencies
#=========================================

set -x
set -e

apt-get update
apt-get install -y --no-install-recommends git unzip python python-pip python-dev build-essential gdal-bin rlwrap golang-go
#rm -rf /var/lib/apt/lists/*

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

git clone https://github.com/whosonfirst/go-whosonfirst-clone.git $TOOLS/wof-clone
cd $TOOLS/wof-clone
make deps
make bin

# we need a custom pelias dbclient version
#git clone https://github.com/HSLdevcom/dbclient.git $TOOLS/dbclient
#cd $TOOLS/dbclient
#npm install
# make it available for other pelias components
#npm link

#git clone https://github.com/pelias/openaddresses.git $TOOLS/openaddresses
#cd $TOOLS/openaddresses
#npm install
# use custom dbclient
#npm link pelias-dbclient

# Install the Pelias-CLI
npm install -g pelias-cli
