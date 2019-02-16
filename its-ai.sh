#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

mylog() {
        STEP=$1
        MSG=$2

        echo -e "step $STEP: ${GREEN}${MSG}${NOCOLOR}"
        logger "step $STEP: $MSG"
}

myfail() {
        STEP=$1
        MSG=$2

        echo -e "step $STEP ERROR: ${RED}${MSG}${NOCOLOR}"
        logger "step $STEP ERROR: $MSG"
}

# handle command line options
if [[ $1 == "-h" ]]; then
        echo "usage: $0"
        echo " -h prints help"

        exit 1
fi

# step 1
mylog 1 "pre-configuring packages"
sudo dpkg --configure -a

# step 2
mylog 2 "fix and attempt to correct a system with broken dependencies"
sudo apt-get install -f

# step 3
mylog 3 "update apt cache"
sudo apt-get update

# step 4
mylog 4 "upgrade packages"
sudo apt-get upgrade

# step 5
mylog 5 "distribution upgrade"
sudo apt-get dist-upgrade

# step 6
mylog 6 "remove unused packages"
sudo apt-get --purge autoremove

# step 7
mylog 7 "clean up"
sudo apt-get autoclean

# step 8
mylog 8 "enabling rpi camera if not enabled"
grep "start_x=1" /boot/config.txt
if grep "start_x=1" /boot/config.txt
then
        exit
else
        sudo sed -i "s/start_x=0/start_x=1/g" /boot/config.txt
fi

# step 9
mylog 9 "enabling 256 memory to gpu"
grep "gpu_mem=256" /boot/config.txt
if grep "gpu_mem=256" /boot/config.txt
then
        exit
else
        sudo sed -i "s/gpu_mem=128/gpu_mem=256/g" /boot/config.txt
fi

# step 10
mylog 10 "installing docker"
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
sudo usermod -aG docker pi

# step 11
mylog 11 "installing x11docker"
sudo apt-get install -y xdg-utils
wget https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker -O /tmp/x11docker
sudo bash /tmp/x11docker --update
rm /tmp/x11docker

# step 12
mylog 12 "installing x11docker kodi container"
mkdir /home/pi/docker
mkdir /home/pi/docker/kodi
cd /home/pi/docker/kodi && { curl -O https://raw.githubusercontent.com/lpt2007/its-ai/master/apps/kodi/Dockerfile ; cd -; }
sudo docker build -t kodi /home/pi/docker/kodi

if [[ $? == 0 ]]; then
        myfail 3 "nothing really"
fi
