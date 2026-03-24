#!/bin/sh
set -eu

HOST="${1:-127.0.0.1}"
PORT="${2:-2227}"
OUT_DIR="${3:-/tmp/kynx-live-build}"

ROOTFS_STAGE="$OUT_DIR/rootfs-stage"
MEDIA_DIR="$OUT_DIR/media"

sudo apt update
sudo apt install -y squashfs-tools rsync openssh-client

rm -rf "$OUT_DIR"
mkdir -p "$ROOTFS_STAGE" "$MEDIA_DIR/live" "$MEDIA_DIR/boot/grub"

echo "[1/5] exporting media boot assets from running Kynx"
ssh -p "$PORT" root@"$HOST" '
  rm -rf /tmp/kynx-media-export
  mkdir -p /tmp/kynx-media-export/boot/grub
  kynx-grub-write-media /tmp/kynx-media-export/boot/grub/grub.cfg /dev/vda1
  cp -f /boot/vmlinuz-kynx /tmp/kynx-media-export/boot/vmlinuz-kynx
'

scp -P "$PORT" root@"$HOST":/tmp/kynx-media-export/boot/vmlinuz-kynx "$MEDIA_DIR/boot/vmlinuz-kynx"
scp -P "$PORT" root@"$HOST":/tmp/kynx-media-export/boot/grub/grub.cfg "$MEDIA_DIR/boot/grub/grub.cfg"

echo "[2/5] syncing running Kynx rootfs into stage"
rsync -a --numeric-ids --delete \
  -e "ssh -p $PORT" \
  --exclude='/dev/*' \
  --exclude='/proc/*' \
  --exclude='/sys/*' \
  --exclude='/run/*' \
  --exclude='/tmp/*' \
  --exclude='/mnt/*' \
  --exclude='/media/*' \
  --exclude='/root/KynxOS-LTS/*' \
  --exclude='/root/kynx-terminal*' \
  --exclude='/var/cache/apk/*' \
  --exclude='/boot/*' \
  root@"$HOST":/ "$ROOTFS_STAGE"/

mkdir -p "$ROOTFS_STAGE/boot"
cp -f "$MEDIA_DIR/boot/vmlinuz-kynx" "$ROOTFS_STAGE/boot/vmlinuz-kynx"

echo "[3/5] normalizing live stage"
printf '%s\n' 'live' > "$ROOTFS_STAGE/etc/kynx/profile"
printf '%s\n' 'Kynx Live' > "$ROOTFS_STAGE/etc/kynx/edition"

echo "[4/5] creating live/filesystem.squashfs"
mksquashfs "$ROOTFS_STAGE" "$MEDIA_DIR/live/filesystem.squashfs" -comp xz -b 1M -noappend

echo "[5/5] writing summary"
cat > "$OUT_DIR/README.NEXT" << EOL
Kynx live rootfs build completed.

Artifacts:
- $MEDIA_DIR/boot/vmlinuz-kynx
- $MEDIA_DIR/boot/grub/grub.cfg
- $MEDIA_DIR/live/filesystem.squashfs

Next required phase:
- generate live initramfs
- add early boot script to locate and mount filesystem.squashfs
- switch_root into live root
- build final ISO
EOL

echo
echo "Kynx live build prepared at: $OUT_DIR"
echo "Main artifact:"
echo "  $MEDIA_DIR/live/filesystem.squashfs"
