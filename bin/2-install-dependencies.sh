#!/bin/bash
set -x
set -e

#=============
# Folder setup
#=============
TOOLS=$HOME/.pelias

if [ -d $TOOLS ]; then
    rm -r $TOOLS/
fi

mkdir -p $TOOLS
chmod 2775 $TOOLS

#=========================================
# Install importers and their dependencies
#=========================================

set -x
set -e

sudo apt-get update
sudo apt-get install -y --no-install-recommends git unzip python python-pip python-dev build-essential gdal-bin rlwrap golang-go

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# Create nodejs group for npm access
if [ $(getent group nodejs) ]; then
  echo "nodejs group already exists"
else
  sudo addgroup nodejs
fi

sudo usermod -a -G nodejs $(whoami)

# Update npm global directory
mkdir $HOME/.npm-packages
echo 'prefix=${HOME}/.npm-packages' > ~/.npmrc
echo 'NPM_PACKAGES="${HOME}/.npm-packages"' >> ~/.bashrc
echo 'PATH="$NPM_PACKAGES/bin:$PATH"' >> ~/.bashrc

# Download Pelias Repositories
cd $TOOLS
for repository in schema api whosonfirst geonames openaddresses openstreetmap; do
    git clone http://github.com/pelias/${repository}.git
    pushd $repository > /dev/null
    git checkout production # or staging, or remove this line to stay with master
    npm install
    popd > /dev/null
done

git clone https://github.com/whosonfirst/go-whosonfirst-clone.git $HOME/.pelias/wof-clone
cd $HOME/.pelias/wof-clone
make deps
make bin

# Install the Pelias-CLI
npm install -g pelias-cli

# Return to the original calling user
exit
