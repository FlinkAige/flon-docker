#!bin/sh
cd ~/fuwal

apt update
apt install -y libssl-dev libboost-all-dev libgmp3-dev libbz2-dev libreadline-dev libncurses5-dev libusb-1.0-0-dev libudev-dev libusb-dev libusb-1.0-0
apt install libcurl4-gnutls-dev cmake -y
apt install -y g++
apt install libz3-dev

cd /opt/flon
apt-get install -y ./flon.cdt_*-alpha_amd64.deb
