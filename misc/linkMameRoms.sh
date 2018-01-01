#!/bin/bash
#
# linkMameRoms.sh - Script to create symbolic links for MAME roms instead of putting them in the actual MAME directory
#
# RetroPie is set up to have samples inside the same directory as the roms. Unfortunately, most MAME collections use a
# separate folder for samples and roms. On top of that, sometimes people may use a torrent instead of a USB drive to
# add roms to their RetroPie installation. This script will link all the individual files to the given rom directory,
# so they can be managed separately.
#

# Test if the command has 2 arguments. Exit if it does not.
if [ "$#" != "2" ]
then
  echo "Usage: $0 [download directory] [RetroPie rom directory]"
  exit -1
fi

# Test if realpath is installed and exit if it isn't
if ! [ -x "$(command -v realpath)" ]
then
  echo "realpath not installed. Try: sudo apt-get install realpath"
  exit -1
fi

# Get the real paths of the command line arguments
downloadDirectory=`realpath "$1"`
retroPieDirectory=`realpath "$2"`

# Test if the directories exist.
# TODO: realpath may be able to take care of this already
if [ ! -d "$downloadDirectory" ]
then
  echo "Download directory does not exist: $1"
  exit -1
fi

if [ ! -d "$retroPieDirectory" ]
then
  echo "RetroPie rom directory does not exist: $1"
  exit -1
fi

# This is where the symolic linking actually happens. Push into the target directory and link every zip file individually.
#  Done as a loop instead of "*" because there may be too many files for a command line.
pushd "$retroPieDirectory" > /dev/null
ls -1 "$downloadDirectory"/*.zip |
while read line
do
  echo "Linking: $line"
  ln -s "$line" .
done
popd > /dev/null
