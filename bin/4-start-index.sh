#!/bin/bash

#=============
# Folder setup
#=============
BASE=/mnt
TOOLS=$HOME/.pelias
DATA=$BASE/pelias/
THREADS=$(nproc)
THREADS=THREADS/2

#=================
# Index everything
#=================

set -x
set -e

cd ~/

#start elasticsearch, create index and run importers
# gosu elasticsearch elasticsearch -d
#: sleep 30

# Create the Pelias schema in ElasticSearch
pelias schema#master create_index

# Begin importing OpenAddresses
# node $TOOLS/openaddresses/import --admin-values
cd $TOOLS/openaddresses
git checkout fix-capitalization
setsid bin/import $THREADS --admin-values > $HOME/openaddress-import.log &

# Begin importing OpenStreetMap Addresses
setsid pelias openstreetmap#master import --admin-values > $HOME/openstreetmap-import.log &

# Begin importing Geonames Addresses
setsid pelias geonames import -i US