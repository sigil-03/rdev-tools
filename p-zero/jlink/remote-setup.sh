#!/bin/bash

REMOTE_USER=${USER}
REMOTE_DEVICE=$1

# make a remote temp directory
ssh ${REMOTE_USER}@$REMOTE_DEVICE mkdir -p ~/tmp

# copy the device setup script to the temp directory
rsync ./device-setup.sh ${REMOTE_USER}@${REMOTE_DEVICE}:~/tmp/

# make setup script executable and execute
ssh ${REMOTE_USER}@${REMOTE_DEVICE} chmod +x ~/tmp/device-setup.sh 
ssh ${REMOTE_USER}@${REMOTE_DEVICE} . ~/tmp/device-setup.sh