#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="viceextra"
rp_module_desc="C64 emulator VICE - extra for SCPU and Joyport Swapping"
rp_module_help="ROM Extensions: .crt .d64 .g64 .prg .t64 .tap .x64 .zip .vsf\n\nCopy your Commodore 64 games to $romdir/c64"
rp_module_licence="GPL2 http://svn.code.sf.net/p/vice-emu/code/trunk/vice/COPYING"
rp_module_repo="svn svn://svn.code.sf.net/p/vice-emu/code/tags/v3.5/vice - HEAD"
rp_module_section="opt"
rp_module_flags=""

function configure_viceextra() {
    addEmulator 0 "vice-xscpu64" "c64" "/opt/retropie/emulators/vice/bin/vice.sh xscpu64 %ROM%"
    addEmulator 0 "vice-x64-joy2" "c64" "/opt/retropie/emulators/vice/bin/vice.sh x64 %ROM% -joydev1 2 -joydev2 1"
    addEmulator 0 "vice-x128-joy2" "c64" "/opt/retropie/emulators/vice/bin/vice.sh x128 %ROM% -joydev1 2 -joydev2 1"
    addEmulator 0 "vice-x64-nojiffy" "c64" "/opt/retropie/emulators/vice/bin/vice.sh x64 -config /opt/retropie/configs/c64/sdl-vicerc-nojiffy %ROM%"
}
