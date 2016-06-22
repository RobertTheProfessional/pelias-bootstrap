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
    cp $CURRENT_DIRECTORY/* /tmp/pelias-bootstrap
    chown -r pelias:pelias /tmp/pelias-bootstrap
    su pelias -c 'mv /tmp/pelias-bootstrap $HOME/Pelias'
fi