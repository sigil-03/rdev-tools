#!/bin/bash

REMOTE_USER=${USER}
REMOTE_DEVICE=$1

# make a remote temp directory
ssh ${REMOTE_USER}@${REMOTE_DEVICE} mkdir -p ~/tmp

# make a rdev user group
ssh ${REMOTE_USER}@${REMOTE_DEVICE} sudo groupadd fw-dev && sudo usermod -aG ${REMOTE_USER} rdev

# make a remote tools directory
ssh ${REMOTE_USER}@${REMOTE_DEVICE} sudo mkdir /tools && sudo chgrp -R /tools && sudo chmod g+rwxs /tools

# copy the device setup script to the temp directory
rsync -r ./device ${REMOTE_USER}@${REMOTE_DEVICE}:~/tmp/

# make setup script executable and execute
ssh ${REMOTE_USER}@${REMOTE_DEVICE} chmod +x ~/tmp/device/device-setup.sh 
ssh ${REMOTE_USER}@${REMOTE_DEVICE} . ~/tmp/device/device-setup.sh
