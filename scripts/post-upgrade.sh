#!/bin/sh
set -e

LOG_FILE="/var/log/kynx-kupgrade.log"
KYNX_DATA="/usr/share/kynx"
SRC_GRUB="$KYNX_DATA/system/grub"
DST_GRUB="/boot/grub/themes/kynx"

mkdir -p /var/log
mkdir -p "$DST_GRUB"

echo "===== Kynx post-upgrade =====" >> "$LOG_FILE"
date >> "$LOG_FILE"

if [ -f "$SRC_GRUB/logo.png" ]; then
    cp -f "$SRC_GRUB/logo.png" "$DST_GRUB/logo.png"
    echo "Copied: $SRC_GRUB/logo.png -> $DST_GRUB/logo.png" >> "$LOG_FILE"
fi

if [ -f "$SRC_GRUB/kynx-wallpapers-grub.jpg" ]; then
    cp -f "$SRC_GRUB/kynx-wallpapers-grub.jpg" "$DST_GRUB/kynx-wallpapers-grub.jpg"
    echo "Copied: $SRC_GRUB/kynx-wallpapers-grub.jpg -> $DST_GRUB/kynx-wallpapers-grub.jpg" >> "$LOG_FILE"
fi

echo "Post-upgrade completed successfully." >> "$LOG_FILE"
