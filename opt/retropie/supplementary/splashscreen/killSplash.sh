#!/bin/sh
#
# This script will kill the splash screen once a game has been autostarted
#

until runcommand=$(ps -ef | grep runcommand.sh | grep -v grep)
do
  sleep 1
done

sleep 5
ps -ef | grep omxplayer | grep -v grep | awk '{print $2}' | sudo xargs kill -9
