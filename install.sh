#!/bin/bash
#
# install.sh
# Courtesy of George McMullen
#
# This script will copy over the various customization files into the RetroPie installation.
#

# TODO: Check to make sure we are in the directory that the script is in

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
# bc is needed to perform mathematical operations on the screen resolution
#
apt-get install bc
