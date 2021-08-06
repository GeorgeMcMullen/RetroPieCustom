#!/bin/sh
#
# This script will kill the splash screen once a game has been autostarted
#

until runcommand=$(ps -ef | egrep "emulationstation|runcommand.sh" | grep -v grep)
do
  /bin/sleep 1
done

/bin/sleep 10
ps -ef | grep omxplayer | grep -v grep | awk '{print $2}' | sudo xargs kill -9 > /dev/null 2>&1
ps -ef | grep omxiv | grep -v grep | awk '{print $2}' | sudo xargs kill -9 > /dev/null 2>&1
