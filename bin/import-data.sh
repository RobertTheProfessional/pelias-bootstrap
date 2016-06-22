#!/bin/bash

#=============
# Folder setup
#=============
BASE=/mnt
TOOLS=$BASE/pelias/tools
DATA=$BASE/pelias/data

# Clear out previous folders if they exist
if [ -d $DATA ]; then
    rm -rf $DATA/
fi

if [ -d $TOOLS ]; then
    rm -rf $TOOLS/
fi

mkdir -p $TOOLS
mkdir -p $DATA

chmod 2775 $TOOLS
chmod 2775 $DATA

# Auxiliary folders
mkdir -p $DATA/openstreetmap
mkdir -p $DATA/openaddresses
mkdir -p $DATA/whosonfirst

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
git clone https://github.com/HSLdevcom/dbclient.git $TOOLS/dbclient
cd $TOOLS/dbclient
npm install
# make it available for other pelias components
npm link

git clone https://github.com/pelias/openaddresses.git $TOOLS/openaddresses
cd $TOOLS/openaddresses
npm install
# use custom dbclient
npm link pelias-dbclient

#==============
# Download data
#==============

# Download the Bootstrap tar to the temp dir
cd /tmp
cp ~/resources/pelias-bootstrap.tar pelias-bootstrap.tar

# Extract the bootstrap files
tar -xf pelias-bootstrap.tar

# Move the extracted files to the data directory
cd data/
mv * $DATA/

cd /root

#=================
# Index everything
#=================

#start elasticsearch, create index and run importers
# gosu elasticsearch elasticsearch -d
npm install -g pelias-cli
sleep 30
pelias schema#master create_index
node $TOOLS/openaddresses/import --admin-values
pelias openstreetmap#master import


#=======
#cleanup
#=======

rm -r $DATA
rm -r $TOOLS
#rm -r $HOME/.pelias
apt-get purge -y git unzip python python-pip python-dev build-essential gdal-bin rlwrap golang-go
apt-get clean
