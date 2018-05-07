#!/bin/sh

ROOTDIR="/opt/retropie"
DATADIR="/home/pi/RetroPie"
RANDOMIZE="disabled"
REGEX_VIDEO="\.avi\|\.mov\|\.mp4\|\.mkv\|\.3gp\|\.mpg\|\.mp3\|\.wav\|\.m4a\|\.aac\|\.ogg\|\.flac"
REGEX_IMAGE="\.bmp\|\.jpg\|\.jpeg\|\.gif\|\.png\|\.ppm\|\.tiff\|\.webp"

do_start () {
    local config="/etc/splashscreen.list"
    local line
    local re="$REGEX_VIDEO\|$REGEX_IMAGE"
    case "$RANDOMIZE" in
        disabled)
            line="$(head -1 "$config")"
            ;;
        retropie)
            line="$(find "$ROOTDIR/supplementary/splashscreen" -type f | grep "$re" | shuf -n1)"
            ;;
        custom)
            line="$(find "$DATADIR/splashscreens" -type f | grep "$re" | shuf -n1)"
            ;;
        all)
            line="$(find "$ROOTDIR/supplementary/splashscreen" "$DATADIR/splashscreens" -type f | grep "$re" | shuf -n1)"
            ;;
        list)
            line="$(cat "$config" | shuf -n1)"
            ;;
    esac
    if $(echo "$line" | grep -q "$REGEX_VIDEO"); then
        # wait for dbus
        while ! pgrep "dbus" >/dev/null; do
            sleep 1
        done

        # These additions help fake aspect fit on vertical screens, which OMX Player can't do yet.
        screenResolution="$(tvservice -s | sed 's/ \@.*// ; s/^.*\, //')"
        screenWidth="$(echo $screenResolution | sed 's/x.*//')"
        screenHeight="$(echo $screenResolution | sed 's/.*x//')"

        if [ "$screenWidth" -gt "$screenHeight" ]
        then
          # When the screen is a standard landscape layout, letterbox seems to work fine
          omxplayer -o both -b --layer 10000 --aspect-mode letterbox "$line"
        else
          # When the screen is in portrait mode, we need to calculate the correct aspect ratio manually
          videoHeight="$(mediainfo "$line" | grep Height | sed 's/ //g ; s/^.*\:// ; s/pixel.*//')"
          videoWidth="$(mediainfo "$line" | grep Width | sed 's/ //g ; s/^.*\:// ; s/pixel.*//')"
          screenY1=`calc "ceil(($screenHeight-ceil((($screenWidth/$videoWidth)*$videoHeight)))/2)"`
          screenY2=`calc "$screenHeight-$screenY1"`
          omxplayer -o both -b --layer 10000 --aspect-mode stretch --win "0 $screenY1 $screenWidth $screenY2" "$line"
        fi
        # End additions
    elif $(echo "$line" | grep -q "$REGEX_IMAGE"); then
        if [ "$RANDOMIZE" = "disabled" ]; then
            local count=$(wc -l <"$config")
        else
            local count=1
        fi
        [ $count -eq 0 ] && count=1
        [ $count -gt 20 ] && count=20
        local delay=$((20/count))
        if [ "$RANDOMIZE" = "disabled" ]; then
            fbi -T 2 -once -t $delay -noverbose -a -l "$config" >/dev/null 2>&1
        else
            fbi -T 2 -once -t $delay -noverbose -a "$line" >/dev/null 2>&1
        fi
    fi
    exit 0
}

case "$1" in
    start|"")
        do_start &
        ;;
    restart|reload|force-reload)
        echo "Error: argument '$1' not supported" >&2
        exit 3
       ;;
    stop)
        # No-op
        ;;
    status)
        exit 0
        ;;
    *)
        echo "Usage: asplashscreen [start|stop]" >&2
        exit 3
        ;;
esac

:
