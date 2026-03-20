#!/bin/sh
set -eu

MODE="${1:-}"

print_disks() {
  echo "Available target disks:"
  if command -v lsblk >/dev/null 2>&1 && [ -d /sys/dev/block ]; then
    lsblk -d -o NAME,SIZE,MODEL | sed '1d' | awk '{print "/dev/"$1, $2, substr($0, index($0,$3))}'
    return 0
  fi

  awk '
    $4 ~ /^(vd|sd|hd|nvme)[a-z0-9]+$/ {
      print "/dev/" $4
    }
  ' /proc/partitions
}

check_disk() {
  DISK="${1:-}"
  [ -b "$DISK" ] || { echo "invalid disk: $DISK"; exit 1; }
}

case "$MODE" in
  probe)
    print_disks
    ;;
  dry-run)
    DISK="${2:-}"
    check_disk "$DISK"
    echo "Kynx Installer Dry Run"
    echo "Target disk: $DISK"
    echo "Planned layout:"
    echo "  - wipe disk"
    echo "  - create single ext4 root partition"
    echo "  - copy Kynx system"
    echo "  - write fstab"
    echo "  - install boot files"
    echo "  - prepare GRUB boot"
    ;;
  *)
    echo "usage:"
    echo "  kynx-installer-core probe"
    echo "  kynx-installer-core dry-run /dev/sdX"
    exit 1
    ;;
esac
