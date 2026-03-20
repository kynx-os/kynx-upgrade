#!/bin/sh
set -eu

DESKTOP="${1:-}"
[ -n "$DESKTOP" ] || {
  echo "usage: kynx-desktop-apply <minimal|xfce|gnome|kde>"
  exit 1
}

mkdir -p /etc/kynx

/usr/bin/kynx-desktop-validate "$DESKTOP"

echo "$DESKTOP" > /etc/kynx/desktop-choice

case "$DESKTOP" in
  minimal)
    echo "Kynx Minimal Desktop" > /etc/kynx/desktop-name
    echo "desktop selected: minimal"
    ;;
  xfce)
    echo "XFCE Desktop" > /etc/kynx/desktop-name
    echo "desktop selected: xfce"
    ;;
  gnome)
    echo "GNOME Desktop" > /etc/kynx/desktop-name
    echo "desktop selected: gnome"
    echo "note: package installation hook for GNOME comes next"
    ;;
  kde)
    echo "KDE Plasma Desktop" > /etc/kynx/desktop-name
    echo "desktop selected: kde"
    echo "note: package installation hook for KDE comes next"
    ;;
esac
