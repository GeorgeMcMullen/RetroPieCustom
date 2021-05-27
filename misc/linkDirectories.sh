#!/bin/sh

cd /home/pi/RetroPie/roms/

rmdir atari2600
rmdir atari5200
rmdir atari7800
rmdir atarilynx
rmdir c64
rmdir gamegear
rmdir gb
rmdir gba
rmdir gbc
rmdir mame-libretro
rmdir mastersystem
rmdir megadrive
rmdir neogeo
rmdir nes
rmdir pcengine
rmdir sg-1000
rmdir snes
rmdir vectrex

ln -s '/home/pi/Downloads/roms/Atari 2600/Roms/ROMS/' atari2600
ln -s '/home/pi/Downloads/roms/Atari - 5200/' atari5200
ln -s '/home/pi/Downloads/roms/Atari - 7800/' atari7800
ln -s '/home/pi/Downloads/roms/Atari - Lynx/' atarilynx
ln -s /home/pi/Downloads/roms/C64/Games/ c64
ln -s '/home/pi/Downloads/roms/Cylum'\''s Sega Master System and Game Gear ROM Sets (2014)/Sega Game Gear/[USA]/' gamegear
ln -s '/home/pi/Downloads/roms/Cylum'\''s Game Boy (Color) ROM Set (2014)/Game Boy/Game Titles - #-Z/' gb
ln -s '/home/pi/Downloads/roms/GBA ROMs/' gba
ln -s '/home/pi/Downloads/roms/Cylum'\''s Game Boy (Color) ROM Set (2014)/Game Boy Color/Game Titles - #-Z/' gbc
ln -s '/home/pi/Downloads/roms/MAME 0.78 Non-Merged/roms/' mame-libretro
ln -s '/home/pi/Downloads/roms/Cylum'\''s Sega Master System and Game Gear ROM Sets (2014)/Sega Master System/[USA]/' mastersystem
ln -s '/home/pi/Downloads/roms/Cylum'\''s Sega Genesis ROM Set (2014)/Game Titles - #-Z/' megadrive
ln -s '/home/pi/Downloads/roms/neo-geo-aes-romset/' neogeo
ln -s /home/pi/Downloads/roms/NES/NESrompack/extracted/USA/ nes
ln -s '/home/pi/Downloads/roms/Turbo Grafix 16/Roms/PCERen/' pcengine
ln -s '/home/pi/Downloads/roms/Cylum'\''s Sega Master System and Game Gear ROM Sets (2014)/SG-1000/' sg-1000
ln -s '/home/pi/Downloads/roms/Cylum'\''s SNES ROM Set (2014)/Game Titles - #-Z/' snes
ln -s '/home/pi/Downloads/roms/GCE - Vectrex/' vectrex

# Copying files over and pausing in between each file
find /media/usb1/home/pi/Downloads/roms/MAME0.106-Reference-Set-ROMs-CHDs-Samples-Split/ -print -exec cp {} . \; sleep 1 \;
