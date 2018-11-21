#!/bin/bash
#
# install.sh
# Courtesy of George McMullen
#
# This script will copy over the various customization files into the RetroPie installation.
#

# TODO: Check to make sure we are in the directory that the script is in

#
# apcalc is needed to perform mathematical operations on the screen resolution
# mediainfo is needed to get a video's height and weight in order to calculate the proper aspect fit
# wiringpi is used by the setVideo.sh to turn the backlight on and off
# raspi-gpio is required for the installation of the Adafruit Kippah as per https://learn.adafruit.com/adafruit-dpi-display-kippah-ttl-tft/installation
#
apt-get install apcalc mediainfo wiringpi raspi-gpio

#
# Get the current date and time to timestamp any backups we make
#
BACKUPDATE=$(date +'%Y%m%d%H%M')

#
# Move the existing config.txt to a backup location
#
mv /boot/config.txt /boot/config-${BACKUPDATE}.bak

#
# Copy all the new config files to /boot/ (for things like LCD vs. HDMI output)
#
cp boot/config*.txt /boot/

#
# Copy a special asound file that will be used for USB sound cards.
#
cp etc/asound-usb.conf /etc/

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
chmod a+rx /opt/retropie/supplementary/splashscreen/killSplash.sh
chmod a+rx /opt/retropie/supplementary/splashscreen/asplashscreen.sh

