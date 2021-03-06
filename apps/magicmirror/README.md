# How to manual install using ssh:
Download Raspbian Stretch with desktop image from:
https://www.raspberrypi.org/downloads/raspbian/
and flash it to sdcard using balenaetcher:
https://www.balena.io/etcher/
Insert sdcard to raspberry pi, when system boots enable ssh with this commands:
```
sudo apt-get update
sudo systemctl enable ssh
sudo reboot
```
install docker if already not installed with command:
```
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
sudo usermod -aG docker pi
```
run raspi-config:
```
sudo raspi-config
```
go to -> "Interfacing Options" -> "Camera" -> Enable,

go to -> "Advanced Options" -> "Memory Split" -> 256

go to -> "Finish" -> "Reboot"

I create folders:
```
mkdir /home/pi/docker
mkdir /home/pi/docker/magicmirror
```
transfer Dockerfile to /home/pi/docker/magicmirror:
```
cd /home/pi/docker/magicmirror
wget https://raw.githubusercontent.com/lpt2007/its-ai/master/apps/magicmirror/Dockerfile
wget https://raw.githubusercontent.com/lpt2007/its-ai/master/apps/magicmirror/docker-entrypoint.sh
```
build docker container:
```
sudo docker build -t magicmirror /home/pi/docker/magicmirror
```

from ssh run this:
```
docker run --rm -v /dev/snd:/dev/snd -v /dev/fb0:/dev/fb0 -v /tmp/.X11-unix:/tmp/.X11-unix -v /usr/bin/tvservice:/usr/bin/tvservice -e DISPLAY=unix$DISPLAY --privileged magicmirror
```

Enjoy. :)
