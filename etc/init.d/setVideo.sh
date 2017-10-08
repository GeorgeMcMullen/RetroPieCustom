#!/bin/bash
#
# Configure video mode on start and before reboot

### BEGIN INIT INFO
# Provides:          setVideo
# Required-Start:    
# Required-Stop:     
# Default-Start:     S
# Default-Stop:      0 1 6
# Short-Description: Configure video mode on start and before reboot
# Description:       This script will check to see if TVService detects
#                    something plugged into the HDMI port and then change
#                    the config.txt accordingly.
### END INIT INFO

#. /lib/lsb/init-functions

videoChanged="false"

# store the output of the tvservice commands
TVN=$(/opt/vc/bin/tvservice -n)

# if the above command matches the HDMI display detected pattern
if [ $(echo "$TVN" | egrep -c "device_name") -gt 0 ]
then
    # we're plugged into HDMI
    OUTPUT="hdmi"
    /usr/bin/gpio -g mode  27 out; # Set GPIO pin 27 to output mode
    /usr/bin/gpio -g write 27 0;   # Set GPIO pin 27 to 0 to turn backlight off
else
    # we're plugged into something else
    OUTPUT="other"
    /usr/bin/gpio -g mode  27 out; # Set GPIO pin 27 to output mode
    /usr/bin/gpio -g write 27 1;   # Set GPIO pin 27 to 1 to turn backlight on
fi

# when plugged into HDMI, run this
if [ "$OUTPUT" == "hdmi" ]
then
    # if a line starts "my_parameter" without a comment
    if [ $(egrep -c "^# Video Mode: LCD" /boot/config.txt) -gt 0 ]
    then
        # Configure the Raspberry Pi for HDMI and Reboot
        echo "Rebooting into HDMI mode"
        /bin/cp /boot/config-hdmi.txt /boot/config.txt
        /bin/rm /etc/asound.conf
        /bin/sync
        videoChanged="true"
    fi
fi

# when plugged into Composite, run this
if [ "$OUTPUT" == "other" ]
then
    # if a line starts "#my_parameter" commented out
    if [ $(egrep -c "^# Video Mode: HDMI" /boot/config.txt) -gt 0 ]
    then
        # Configure the Raspberry Pi for the alternate video mode
        echo "Rebooting into LCD screen mode"
        /bin/cp /boot/config-kippah.txt /boot/config.txt
        /bin/cp /etc/asound-usb.conf /etc/asound.conf
        /bin/sync
        videoChanged="true"
    fi
fi

case $1 in
        start)
               if [ "$videoChanged" == "true" ]
               then
                 /sbin/reboot
               fi
               ;;
        stop)
                ;;
        *)
                echo "Usage: /etc/init.d/setVideo.sh {start|stop}"
                exit 1
                ;;
esac

exit 0
