#!/bin/bash
#
# install.sh
# Courtesy of George McMullen
#
# This script will copy over the various customization files into the RetroPie installation.
#

# Check to make sure we are in the directory that the script is in
scriptDirectory=`dirname $0`
test -z "$scriptDirectory" && scriptDirectory=.
pushd $scriptDirectory

#
# apcalc is needed to perform mathematical operations on the screen resolution
# mediainfo is needed to get a video's height and weight in order to calculate the proper aspect fit
# wiringpi is used by the setVideo.sh to turn the backlight on and off
# raspi-gpio is required for the installation of the Adafruit Kippah as per https://learn.adafruit.com/adafruit-dpi-display-kippah-ttl-tft/installation
# python-pip is required to test the Picade keyboard mappings
#
apt-get install apcalc mediainfo wiringpi raspi-gpio python-pip

# Make sure the Downloads directory exists
if [ ! -d "/home/pi/Downloads/" ]
then
  mkdir -p /home/pi/Downloads
  chown pi:pi /home/pi/Downloads
fi

# Install device tree blob for Adafruit Kippah
pushd /home/pi/Downloads/
wget https://raw.githubusercontent.com/adafruit/Adafruit-DPI-Kippah/master/dt-blob.bin
cp dt-blob.bin /boot/
popd

#
# Get the current date and time to timestamp any backups we make
#
BACKUPDATE=$(date +'%Y%m%d%H%M')

#
# Backup the existing config.txt to a backup location
#
cp /boot/config.txt /boot/config-${BACKUPDATE}.bak

#
# Copy all the new config files to /boot/ (for things like LCD vs. HDMI output)
# Remove the config files you do not need (for DPI or DSI screens)
#
cp boot/config*.txt /boot/

#
# Copy alsa config files that will be used for USB sound cards
# For more information:
#    https://learn.adafruit.com/usb-audio-cards-with-a-raspberry-pi/
#    https://learn.adafruit.com/usb-audio-cards-with-a-raspberry-pi/updating-alsa-config
#
cp /usr/share/alsa/alsa.conf /usr/share/alsa/alsa-${BACKUPDATE}.bak
cp usr/share/alsa/alsa*.conf /usr/share/alsa/
cp /usr/share/alsa/alsa-usb.conf /usr/share/alsa/alsa.conf

#
# Install a new startup/shutdown script that will detect the video output
# and set up the operating system (with config.txt, sound, and GPIO backlight)
#
cp etc/init.d/setVideo.sh /etc/init.d
chmod a+rx /etc/init.d/setVideo.sh
update-rc.d setVideo.sh defaults

#
# Copy new splashscreen file and killer to appropriate directories and change permission
#
cp opt/retropie/supplementary/splashscreen/killSplash.sh /opt/retropie/supplementary/splashscreen/killSplash.sh
cp opt/retropie/supplementary/splashscreen/asplashscreen.sh /opt/retropie/supplementary/splashscreen/asplashscreen.sh
cp opt/retropie/supplementary/splashscreen/black-background.png /opt/retropie/supplementary/splashscreen/black-background.png
chmod a+rx /opt/retropie/supplementary/splashscreen/killSplash.sh
chmod a+rx /opt/retropie/supplementary/splashscreen/asplashscreen.sh

#
# Configuration files for C64 Emulator
#
sudo pi cp opt/retropie/configs/c64/* /opt/retropie/configs/c64/

#
# We need a special Vice launch script because Vice currently doesn't like -config to not be the first argument
#
cp opt/retropie/emulators/vice/bin/vice.sh /opt/retropie/emulators/vice/bin/vice.sh 

#
# Install Custom RetroPie Scripts
#
currentPath=`pwd`
sudo pi ln -s $currentPath /home/pi/RetroPie-Setup/ext/RetroPieCustom
pushd /home/pi/RetroPie-Setup/
./retropie_packages.sh viceextra configure
popd

#
# Add games that require tap and no joysticks to C64
#
cat opt/retropie/configs/all/emulators.cfg >> /opt/retropie/configs/all/emulators.cfg

#
# Required libraries for reading the Picade
#
pip install evdev pyserial
