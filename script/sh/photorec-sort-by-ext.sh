#!/bin/bash

recup_dir="${1%/}"

[ -d "$recup_dir" ] || {
    echo "Usage: $0 recup_dir";
    echo "Mirror files from recup_dir into recup_dir.by_ext, organized by extension";
    exit 1
};
find "$recup_dir" -type f | while read k; do
    ext="${k##*.}";
    ext_dir="$recup_dir.by_ext/$ext";
    [ -d "$ext_dir" ] || mkdir -p "$ext_dir";
    echo "${k%/*}"
    ln "$k" "$ext_dir";

done
#   https://www.cgsecurity.org/wiki/After_Using_PhotoRec
#   Save it as photorec-sort-by-ext and run
#   $ bash photorec-sort-by-ext /home/me/recovered_files
#   This will create a folder called /home/me/recovered_files.by_ext

# cd /mnt/fedora_home/recovery
# sudo ~/PSG/script/sh/photorec-sort-by-ext.sh /mnt/fedora_home/recovery/photorec
# result in /mnt/fedora_home/recovery/photorec.by_ext 
# need root else complain can't create hard link....
