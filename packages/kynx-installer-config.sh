#!/bin/sh
set -eu

MODE="${1:-}"
KEY="${2:-}"
VAL="${3:-}"

mkdir -p /etc/kynx/install

case "$MODE" in
  set)
    [ -n "$KEY" ] && [ -n "$VAL" ] || {
      echo "usage: kynx-installer-config set <key> <value>"
      exit 1
    }
    echo "$VAL" > "/etc/kynx/install/$KEY"
    echo "set: $KEY=$VAL"
    ;;
  get)
    [ -n "$KEY" ] || {
      echo "usage: kynx-installer-config get <key>"
      exit 1
    }
    cat "/etc/kynx/install/$KEY"
    ;;
  summary)
    for f in /etc/kynx/install/*; do
      [ -f "$f" ] || continue
      echo "$(basename "$f")=$(cat "$f")"
    done
    ;;
  *)
    echo "usage:"
    echo "  kynx-installer-config set <key> <value>"
    echo "  kynx-installer-config get <key>"
    echo "  kynx-installer-config summary"
    exit 1
    ;;
esac
