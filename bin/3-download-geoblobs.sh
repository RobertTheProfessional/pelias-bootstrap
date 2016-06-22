#!/bin/bash

#=============
# Folder setup
#=============
BASE=/mnt
DATA=$BASE/pelias/data

# Clear out previous folders if they exist
if [ -d $DATA ]; then
    rm -rf $DATA/
fi

mkdir -p $DATA

chmod 2775 $DATA

# Auxiliary folders
mkdir -p $DATA/openstreetmap
mkdir -p $DATA/openaddresses
mkdir -p $DATA/whosonfirst

set -x
set -e

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

