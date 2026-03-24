#!/bin/sh
set -eu

OUT_DIR="${1:-/tmp/kynx-media}"
KERNEL_SRC="/usr/share/kynx/system/boot/vmlinuz-kynx"
KERNEL_DST="$OUT_DIR/boot/vmlinuz-kynx"
GRUB_CFG="$OUT_DIR/boot/grub/grub.cfg"

mkdir -p "$OUT_DIR/boot/grub" "$OUT_DIR/live" "$OUT_DIR/EFI/BOOT"

if [ -f "$KERNEL_SRC" ]; then
  cp -f "$KERNEL_SRC" "$KERNEL_DST"
fi

cat > "$GRUB_CFG" << 'EOL'
set timeout=5
set default=0

if background_image /usr/share/kynx/system/grub/kynx-wallpapers-grub.jpg; then
  true
fi

menuentry "Kynx OS - Live" {
  linux /boot/vmlinuz-kynx quiet loglevel=3 vt.global_cursor_default=0 kynx.profile=live
}

menuentry "Kynx OS - Graphic Install" {
  linux /boot/vmlinuz-kynx quiet loglevel=3 vt.global_cursor_default=0 kynx.profile=install-gui
}

menuentry "Kynx OS - Text Install" {
  linux /boot/vmlinuz-kynx quiet loglevel=3 vt.global_cursor_default=0 kynx.profile=install-tui
}
EOL

cat > "$OUT_DIR/live/README.NEXT" << 'EOL'
Kynx media skeleton prepared.

Current status:
- GRUB media menu: ready
- kernel asset staged if available
- live profile entries wired

Next phase required:
- generate/initramfs for media boot
- create live rootfs image
- wire squashfs/overlay live boot flow
- build final ISO
EOL

echo "Kynx media layout prepared at: $OUT_DIR"
