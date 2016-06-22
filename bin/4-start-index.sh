#!/bin/bash

#=============
# Folder setup
#=============
BASE=/mnt
TOOLS=$BASE/pelias/tools
DATA=$BASE/pelias/data
THREADS=6

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
cd $TOOLS/openaddresses && bin/import $THREADS --admin-values

# Begin importing OpenStreetMap Addresses
pelias openstreetmap#master import
