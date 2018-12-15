#
# readPicade.py - Will output the buttons pressed by the Picade for testing purposes
#
# Code via: https://superuser.com/questions/562434/how-can-i-read-input-from-the-hosts-keyboard-when-connected-via-ssh
#

# TODO: Change output to include value as well as character
# TODO: Change output so it doesn't crash on cursor key presses
# TODO: Detection of InputDevice or command line parameter
import string

from evdev import InputDevice
from select import select

keys = "X^1234567890XXXXqwertzuiopXXXXasdfghjklXXXXXyxcvbnmXXXXXXXXXXXXXXXXXXXXXXX"
dev = InputDevice('/dev/input/by-id/usb-Arduino_LLC_Arduino_Leonardo_HIDFG-if02-event-joystick')

while True:
   r,w,x = select([dev], [], [])
   for event in dev.read():
        if event.type==1 and event.value==1:
                print( event.code )
                print( keys[ event.code ] )
