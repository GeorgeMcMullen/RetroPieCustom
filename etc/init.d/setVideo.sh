#!/bin/sh
# /etc/init.d/setVideo.sh
#
# Configure video mode on start and before reboot

### BEGIN INIT INFO
# Provides:          setVideo.sh
# Required-Start:    
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Configure video mode on start and before reboot
# Description:       This script will check to see if TVService detects
#                    something plugged into the HDMI port and then change
#                    the config.txt accordingly.
#
#                    To install, run:
#                      sudo update-rc.d setVideo.sh defaults
#                    To remove, run:
#                      update-rc.d -f setVideo.sh remove
### END INIT INFO

echo "Checking video configuration..."

#. /lib/lsb/init-functions

videoChanged="false"
configFile="/boot/config.txt"

# Inline Python Script to set volume of Picade
picadeVolumeScript="
import serial
picade = serial.Serial('/dev/ttyACM0',9600,timeout=1.0)
string='--------------------++++++++++++++++s'

try:
    picade.reset_input_buffer()
except AttributeError:
    picade.flushInput()

picade.write(string)

for i in range(len(string)):
    print(picade.readline().strip())

print(picade.readline().strip())

"

picadeVolumeScriptMute="
import serial
picade = serial.Serial('/dev/ttyACM0',9600,timeout=1.0)
string='--------------------s'

try:
    picade.reset_input_buffer()
except AttributeError:
    picade.flushInput()

picade.write(string)

for i in range(len(string)):
    print(picade.readline().strip())

print(picade.readline().strip())

"

# store the output of the tvservice commands
TVN=$(/opt/vc/bin/tvservice -v 2 -n) 2> /dev/null

# Do we have multiple configurations for audio?
hasMultipleAudioConfigs=0
if [ -f "/usr/share/alsa/alsa-usb.conf" -o -f "/usr/share/alsa/alsa-hdmi.conf" ]
then
  hasMultipleAudioConfigs=1
fi

# The available config files tell us what hardware configurations we should look for
hasDPIDisplay=0
hasDSIDisplay=0

if [ -f "/boot/config-kippah.txt" ]
then
  echo "DPI/Kippah based display configuration detected"
  hasDPIDisplay=1
fi

if [ -f "/boot/config-dsi.txt" ]
then
  echo "DSI based display configuration detected"
  hasDSIDisplay=1
fi


# if the above command matches the HDMI display detected pattern
if [ $(/bin/echo "$TVN" | /bin/egrep -c "device_name") -gt 0 ]
then
    # we're plugged into HDMI
    echo "HDMI is plugged in"
    OUTPUT="hdmi"
else
    # we're plugged into something else
    echo "HDMI is not plugged in"
    OUTPUT="other"
fi

# When plugged into HDMI, run this
if [ "$OUTPUT" = "hdmi" ]
then
    if [ "$hasDPIDisplay" -gt 0 ]
    then
      /usr/bin/gpio -g mode  27 out; # Set GPIO pin 27 to output mode
      /usr/bin/gpio -g write 27 0;   # Set GPIO pin 27 to 0 to turn backlight off
    fi

    # Test if the config file exists and there is a comment for LCD video mode
    if [ -e "$configFile" ]
    then
      configGrep=$(/bin/egrep -c -e "^# Video Mode: DSI" -e "^# Video Mode: LCD" $configFile 2>/dev/null)
    else
      configGrep=1
    fi
    
    if [ "$configGrep" -gt 0 ]
    then
        # Configure the Raspberry Pi for HDMI and Reboot
        echo "Rebooting into HDMI mode"
        /bin/cp /boot/config-hdmi.txt $configFile
        if [ "$hasMultipleAudioConfigs" -gt 0 ]
        then
          /bin/cp /usr/share/alsa/alsa-hdmi.conf /usr/share/alsa/alsa.conf
          # We need to change Emulation Station's config file. It is not in proper XML format. Setting is based on the output of `amixer`.
          /bin/sed -i -e 's/string name="AudioDevice" value=".*"/string name="AudioDevice" value="HDMI"/g' /opt/retropie/configs/all/emulationstation/es_settings.cfg
        fi
        videoChanged="true"
    fi
    # Set the volume of the Picade
    echo "Setting volume on Picade to zero"
    /usr/bin/python -c "$picadeVolumeScriptMute"
fi

# When not plugged into HDMI (i.e., using the Kippah), run this
if [ "$OUTPUT" = "other" -a "$hasDPIDisplay" -gt 0 ]
then
    /usr/bin/gpio -g mode  27 out; # Set GPIO pin 27 to output mode
    /usr/bin/gpio -g write 27 1;   # Set GPIO pin 27 to 1 to turn backlight on

    # Test if the config file exists and there is a comment for HDMI video mode
    if [ -e "$configFile" ]
    then
      configGrep=$(/bin/egrep -c "^# Video Mode: HDMI" $configFile 2>/dev/null)
    else
      configGrep=1
    fi
    
    if [ "$configGrep" -gt 0 ]
    then
        # Configure the Raspberry Pi for the alternate video mode
        echo "Rebooting into LCD screen mode"
        /bin/cp /boot/config-kippah.txt $configFile
        if [ "$hasMultipleAudioConfigs" -gt 0 ]
        then
          /bin/cp /usr/share/alsa/alsa-usb.conf /usr/share/alsa/alsa.conf
          # We need to change Emulation Station's config file. It is not in proper XML format. Setting is based on the output of `amixer`.
          newMixer=$(/usr/bin/amixer | /bin/grep "^Simple mixer control" | /bin/grep -v "Simple mixer control .Auto Gain Control" | /bin/grep -v "Simple mixer control .Mic" | /usr/bin/head -1 | /bin/sed 's/.*Simple mixer control .//i' | /bin/sed 's/.\,.*//')
          /bin/sed -i -e sed 's/string name="AudioDevice" value=".*"/string name="AudioDevice" value="'$newMixer'"/g' /opt/retropie/configs/all/emulationstation/es_settings.cfg
        fi
        videoChanged="true"
    fi
    # Set the volume of the Picade
    echo "Setting volume on Picade"
    /usr/bin/python -c "$picadeVolumeScript"
fi

# When not plugged into HDMI (i.e., using the DSI display), run this
if [ "$OUTPUT" = "other" -a "$hasDSIDisplay" -gt 0 ]
then
    # Test if the config file exists and there is a comment for HDMI video mode
    if [ -e "$configFile" ]
    then
      configGrep=$(/bin/egrep -c "^# Video Mode: HDMI" $configFile 2>/dev/null)
    else
      configGrep=1
    fi
    
    if [ "$configGrep" -gt 0 ]
    then
        # Configure the Raspberry Pi for the alternate video mode
        echo "Rebooting into DSI screen mode"
        /bin/cp /boot/config-dsi.txt $configFile
        if [ "$hasMultipleAudioConfigs" -gt 0 ]
        then
          /bin/cp /usr/share/alsa/alsa-usb.conf /usr/share/alsa/alsa.conf
          # We need to change Emulation Station's config file. It is not in proper XML format. Setting is based on the output of `amixer`.
          newMixer=$(/usr/bin/amixer | /bin/grep "^Simple mixer control" | /bin/grep -v "Simple mixer control .Auto Gain Control" | /bin/grep -v "Simple mixer control .Mic" | /usr/bin/head -1 | /bin/sed 's/.*Simple mixer control .//i' | /bin/sed 's/.\,.*//')
          /bin/sed -i -e sed 's/string name="AudioDevice" value=".*"/string name="AudioDevice" value="'$newMixer'"/g' /opt/retropie/configs/all/emulationstation/es_settings.cfg
        fi
        videoChanged="true"
    fi
    # Set the volume of the Picade
    echo "Setting volume on Picade"
    /usr/bin/python -c "$picadeVolumeScript"
fi


case $1 in
        start)
               if [ "$videoChanged" = "true" ]
               then
                 /bin/sync
                 echo "Video mode changed, rebooting"
                 /sbin/reboot
               fi
               ;;
        stop)
                # We are stopping, and possibly shutting down, turn the backlight off
                if [ "$hasDPIDisplay" -gt 0 ]
                then
                  /usr/bin/gpio -g mode  27 out; # Set GPIO pin 27 to output mode
                  /usr/bin/gpio -g write 27 0;   # Set GPIO pin 27 to 0 to turn backlight off
                fi
                ;;
        *)
                echo "Usage: /etc/init.d/setVideo.sh {start|stop}"
                exit 1
                ;;
esac

exit 0
