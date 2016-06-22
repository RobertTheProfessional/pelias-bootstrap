#!/bin/bash
set -x
set -e

#=============
# Folder setup
#=============
TOOLS=$HOME/.pelias

if [ -d $TOOLS ]; then
    echo "TOOLS EXISTS!" #rm -r $TOOLS/
fi

mkdir -p $TOOLS

chmod 2775 $TOOLS

#=========================================
# Install importers and their dependencies
#=========================================

set -x
set -e

# Pull the Bootstrap from GitHub
mkdir ~/Pelias && cd ~/Pelias
git clone https://github.com/RobertTheProfessional/pelias-bootstrap

# Create the Pelias resources folder
mkdir $TOOLS && cd $TOOLS

# Download Pelias Repositories
for repository in schema api whosonfirst geonames openaddresses openstreetmap; do
    git clone http://github.com/pelias/${repository}.git
    pushd $repository > /dev/null
    git checkout production # or staging, or remove this line to stay with master
    npm install
    popd > /dev/null
done

apt-get update
apt-get install -y --no-install-recommends git unzip python python-pip python-dev build-essential gdal-bin rlwrap golang-go

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

git clone https://github.com/whosonfirst/go-whosonfirst-clone.git ~/.pelias/wof-clone
cd ~/.pelias/wof-clone
make deps
make bin

# Install the Pelias-CLI
npm install -g pelias-cli

# Return to the original calling user
exit
