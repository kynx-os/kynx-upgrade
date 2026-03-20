#!/bin/sh
set -eu

PROFILE="${1:-}"
if [ -z "$PROFILE" ]; then
  PROFILE="$(cat /etc/kynx/profile 2>/dev/null || echo live)"
fi

case "$PROFILE" in
  live) EDITION_NAME="Kynx Live" ;;
  install-gui) EDITION_NAME="Kynx Graphic Install" ;;
  install-tui) EDITION_NAME="Kynx Text Install" ;;
  *) EDITION_NAME="Kynx OS" ;;
esac

mkdir -p /boot/grub

cat > /boot/grub/grub.cfg << EOL
set timeout=3
set default=0

if background_image /usr/share/kynx/system/grub/kynx-wallpapers-grub.jpg; then
  true
fi

menuentry "Kynx OS - $EDITION_NAME" {
  linux /boot/vmlinuz-kynx root=/dev/vda1 rw rootfstype=ext4 quiet loglevel=3 vt.global_cursor_default=0
}
EOL

echo "grub visible config applied: $EDITION_NAME"
