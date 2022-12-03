#!/usr/bin/bash
#
# This simple script is meant to configure a system that uses Network Manager (like Ubuntu) so that
# it instead uses WPA Supplicant through DHCPCD. This is to make the system more like Raspbian so
# that WiFi can be configured using the RetroPie Setup scripts.
#
# *** WARNING ***
# This script is run as `root`. It is more meant as a reference to the commands you should run,
# and not run blindly.
# *** WARNING ***
#
# More research:
#   https://www.linuxbabe.com/command-line/ubuntu-server-16-04-wifi-wpa-supplicant
#   https://raspberrypi.stackexchange.com/questions/74538/how-do-i-configure-dhcpcd-to-call-wpa-supplicant-for-a-specific-interface
#   https://wiki.somlabs.com/index.php/Connecting_to_WiFi_network_using_systemd_and_wpa-supplicant
#   https://unix.stackexchange.com/questions/453329/where-is-my-etc-wpa-supplicant-conf-on-systemd
#   https://bbs.archlinux.org/viewtopic.php?id=148291
#   https://wiki.archlinux.org/title/wpa_supplicant
#   https://wiki.archlinux.org/title/dhcpcd
#   https://raspberrypi.stackexchange.com/questions/39785/differences-between-etc-dhcpcd-conf-and-etc-network-interfaces
#   https://manpages.debian.org/unstable/dhcpcd5/dhcpcd-run-hooks.8.en.html
#

# Comment out these lines if you think you know what you are doing
echo "This script is meant to be more of a reference and should not be run blindly."
echo "View the script in order to see what commands should be run."
exit

# Make sure the wireless card is enabled using rfkill.
apt install rfkill

# List out the rfkill rules
rfkill list

# If you see either a hard block or soft block, run the following:
rfkill unblock wifi

# Install WPA Supplicant, if not already installed:
apt install wpasupplicant

# A couple of scripts and configuration files are needed from the Raspberry Pi package for dhcpcd in order for it to enable WPA Supplicant in the same way that it is enabled for Raspbian
mkdir -p ~/Downloads/dhcpcd/
cd ~/Downloads/dhcpcd/
wget https://archive.raspberrypi.org/debian/pool/main/d/dhcpcd5/dhcpcd5_7.0.8-0.1+rpt1_armhf.deb
​​
# Stop Network Manager
systemctl stop NetworkManager
systemctl disable NetworkManager

# Remove a couple of configuration files that might hang around
rm /etc/NetworkManager/system-connections/*.nmconnection 
rm /etc/NetworkManager/conf.d/*

# Remove Network Manager
apt remove network-manager
apt purge network-manager

# Create the WPA Supplicant configuration file. Keep in mind that by default all users can read this file, as well as any password that gets added to it
# by the RetroPie Setup script. Investigate if it will still work without global read permissions.
cat /etc/wpa_supplicant/wpa_supplicant.conf << EOF_WPA_SUPPLICANT_CONF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US
EOF_WPA_SUPPLICANT_CONF

# Extract files from the archive we downloaded earlier and install them
ar x dhcpcd5_7.0.8-0.1+rpt1_armhf.deb
tar xvf data.tar.xz
cp ./lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
cp ./etc/dhcpcd.conf /etc/dhcpcd.conf 

# Restart dhcpcd which will in turn enable wpa_supplicant
systemctl restart dhcpcd

#
ifconfig -a
iwconfig

# Ubuntu uses resolveconf via systemd to update the resolv.conf file, but it does so in the /run directory
CURRENTDATETIME=$(date +"%Y%m%d%H%M")
mv /etc/resolv.conf /etc/resolv.conf-$CURRENTDATETIME
ln -s /run/resolvconf/resolv.conf /etc/resolv.conf
systemctl restart resolvconf

# Print a message to remind you to configure WiFi with retropie_setup.sh
echo "Now you can run retropie_setup.sh to configure your WiFi!"
