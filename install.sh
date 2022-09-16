#!/bin/bash

# git clone -b arm https://github.com/kelebek333/rtl8188fu rtl8188fu-arm
# cd rtl8188fu-arm/

ARCH=arm make # override ARCH
sudo MODULE_NAME=rtl8188fu make install # manually set MODULE_NAME
sudo cp firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/
echo 'alias usb:v0BDApF179d*dc*dsc*dp*icFFiscFFipFFin* rtl8188fu' | sudo tee /etc/modprobe.d/r8188eu-blacklist.conf
echo Done. Reboot...
