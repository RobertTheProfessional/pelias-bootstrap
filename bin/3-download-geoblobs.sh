#!/bin/bash

#=============
# Folder setup
#=============
if [ "$PELIAS_INSTALL_ROOT" ]; then
    echo "PELIAS_INSTALL_ROOT environment variable is set to: " $PELIAS_INSTALL_ROOT
else
    PELIAS_INSTALL_ROOT=/opt
fi

DATA=$PELIAS_INSTALL_ROOT/pelias/data
TOOLS=$HOME/.pelias
WOF_META=wof_data/meta
WOF_DATA=wof_data/data

if [ ! -d $PELIAS_INSTALL_ROOT/pelias ]; then
    sudo mkdir $PELIAS_INSTALL_ROOT/pelias
fi

# Take ownership of the Pelias root folder
sudo chown $(whoami):$(whoami) $PELIAS_INSTALL_ROOT/pelias

# Clear out previous folders if they exist
if [ -d $DATA ]; then
    rm -rf $DATA/
fi

mkdir -p $DATA
chmod 2775 $DATA

# Create data folders
mkdir -p $DATA/$WOF_META
mkdir -p $DATA/$WOF_DATA
mkdir -p $DATA/openstreetmap
mkdir -p $DATA/openaddresses
mkdir -p $DATA/whosonfirst

set -x
set -e

#==============
# Download data
#==============

# Download Whos On First admin lookup data
admins=( continent borough country county dependency disputed localadmin locality macrocounty macroregion neighbourhood region )

for target in "${admins[@]}"
do
    echo getting $target metadata
    curl -O -sS $URL/wof-$target-latest.csv
    if [ "$target" != "continent" ] then
	    head -1 wof-$target-latest.csv > temp && cat wof-$target-latest.csv | grep ",US," >> temp || true
	    mv temp wof-$target-latest.csv
    fi
done

cd ../../

for target in "${admins[@]}"
do
    echo getting $target data
    $TOOLS/wof-clone/bin/wof-clone-metafiles -dest $DATADIR $METADIR/wof-$target-latest.csv
done

# Download OpenStreetMap data
cd $DATA/openstreetmap
curl -sS -O http://download.geofabrik.de/north-america-latest.osm.pbf

# Download all '/us/' entries from OpenAddresses
cd $DATA/openaddresses
curl -sS http://results.openaddresses.io/state.txt | sed -e 's/\s\+/\n/g' | grep '/us/.*\.zip' | xargs -n 1 curl -O -sS
ls *.zip | xargs -n 1 unzip -o
rm *.zip README.*