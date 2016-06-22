#!/bin/bash
set -x
set -e

# Create the Pelias user and grant password-less sudo
sudo adduser pelias --gecos "Pelias Administrative User,,," --disabled-password
sudo sh -c "echo \"pelias ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/pelias-admin-user"
sudo chmod 0440 /etc/sudoers.d/pelias-admin-user