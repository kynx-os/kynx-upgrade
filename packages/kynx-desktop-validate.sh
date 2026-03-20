#!/bin/sh
set -eu

DESKTOP="${1:-}"

[ -n "$DESKTOP" ] || {
  echo "usage: kynx-desktop-validate <minimal|xfce|gnome|kde>"
  exit 1
}

case "$DESKTOP" in
  minimal|xfce)
    echo "ok: $DESKTOP (offline-supported)"
    ;;
  gnome|kde)
    if /usr/bin/kynx-net-check >/dev/null 2>&1; then
      echo "ok: $DESKTOP (internet available)"
    else
      echo "error: $DESKTOP requires internet"
      exit 1
    fi
    ;;
  *)
    echo "error: unknown desktop '$DESKTOP'"
    exit 1
    ;;
esac
