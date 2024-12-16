#!/bin/bash
PYTHON_VENV_DIR="/env/remote"

# install pip
sudo apt-get install -y python3-pip

# create venv if it does not exist
if [ ! -d ${PYTHON_VENV_DIR} ]; then
    mkdir -p ${PYTHON_VENV_DIR}
    echo "setting up python VENV"
    python3 -m venv ${PYTHON_VENV_DIR}
fi

# activate venv
. ${PYTHON_VENV_DIR}/bin/activate

# install jlink shit - check if it exists first
if [ ! -d /opt/gcc-arm-none-eabi-10-2020-q4-major ]; then
    echo "installing JLINK drivers"
    curl -fsSL https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-$(uname -m)-linux.tar.bz2 \
        | sudo tar -C /opt -xjvf - \
        --exclude doc \
        --exclude samples
fi

export PATH="/opt/gcc-arm-none-eabi-10-2020-q4-major/bin:${PATH}"

# JLink prerequesites setup
echo "installing JLINK prerequisites"
sudo apt-get update && \
sudo apt-get install -y \
        libfontconfig1 \
        libfreetype6 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-render-util0 \
        libxcb-shape0 \
        libxkbcommon-x11-0 \
        udev \
        usbutils


# JLink setup - for now we just gate with whether or not the jlink udev rules
# file exists...

if [ ! -f /etc/udev/rules.d/99-jlink.rules ]; then
    echo "installing JLINK"
    sudo apt-get update
    cd /tmp
    export PKG_ARCH=$(uname -m | sed s,aarch,arm,)
    export JLINK_VERSION=796a
    curl -O \
        -X POST \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        --data 'accept_license_agreement=accepted&submit=Download+software' \
        https://www.segger.com/downloads/jlink/JLink_Linux_V${JLINK_VERSION}_${PKG_ARCH}.deb
    sudo dpkg --unpack JLink_Linux_V${JLINK_VERSION}_${PKG_ARCH}.deb
    sudo rm JLink_Linux_V${JLINK_VERSION}_${PKG_ARCH}.deb
    sudo rm -f /var/lib/dpkg/info/jlink.postinst
    sudo dpkg --configure jlink
    sudo apt-get --yes --quiet --fix-broken install
    sudo apt-get --yes --quiet --purge autoremove ; sudo apt-get clean

    # copy udev rules file for jlink unit
    sudo mv 99-jlink.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules
fi

# install shit - later fix to check if we need it
pip3 install pylink-square requests progress
