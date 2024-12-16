#!/bin/bash

REMOTE_USER=${USER}
REMOTE_DEVICE=$1
RDEV_GROUP="rdev"
# make a remote temp directory
ssh ${REMOTE_USER}@${REMOTE_DEVICE} mkdir -p ~/tmp

# make a rdev user group
ssh ${REMOTE_USER}@${REMOTE_DEVICE} << EOF 
	sudo groupadd ${RDEV_GROUP} 
	sudo usermod -aG ${RDEV_GROUP} ${REMOTE_USER}
EOF

# make a remote tools directory
ssh ${REMOTE_USER}@${REMOTE_DEVICE} << EOF
	sudo mkdir /tools ;
	sudo chgrp -R ${RDEV_GROUP} /tools ;
	sudo chmod g+rwxs /tools ;
EOF

# make a remote env directory
ssh ${REMOTE_USER}@${REMOTE_DEVICE} << EOF
	sudo mkdir /env ;
	sudo chgrp -R ${RDEV_GROUP} /env ;
	sudo chmod g+rwxs /env ;
EOF

# copy the device setup script to the temp directory
rsync -r ./device ${REMOTE_USER}@${REMOTE_DEVICE}:~/tmp/

# make setup script executable and execute
ssh ${REMOTE_USER}@${REMOTE_DEVICE} << EOF
	chmod +x ~/tmp/device/device-setup.sh ;
	. ~/tmp/device/device-setup.sh ;
EOF
