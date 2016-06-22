#!/bin/bash
set -x
set -e

CURRENT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup the Pelias, if successful install
# Pelias Dependencies and Resources to the
# pelias user's folder
if ./bin/1-setup-user.sh ; then
    # Copy Bootstrap resources to /tmp
    mkdir -p /tmp/pelias-bootstrap
    cp -r $CURRENT_DIRECTORY/* /tmp/pelias-bootstrap
    sudo chown -R pelias:pelias /tmp/pelias-bootstrap
    sudo su pelias -c 'mv /tmp/pelias-bootstrap $HOME/Pelias'

    # Download Pelias Dependencies
    sudo su pelias -c 'bash $HOME/Pelias/bin/2-install-dependencies.sh'
fi