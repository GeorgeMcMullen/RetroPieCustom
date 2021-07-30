#!/bin/bash

BIN="${0%/*}/$1"
ROM="$2"
PARAMS=("${@:3}")

romdir="${ROM%/*}"
ext="${ROM##*.}"
source "/opt/retropie/lib/archivefuncs.sh"

archiveExtract "$ROM" ".cmd .crt .d64 .d71 .d80 .d81 .g64 .prg .m3u .t64 .tap .x64 .zip .vsf"

# check successful extraction and if we have at least one file
if [[ $? == 0 ]]; then
    ROM="${arch_files[0]}"
    romdir="$arch_dir"
fi

"$BIN" "${PARAMS[@]}" -chdir "$romdir" "$ROM"
archiveCleanup
