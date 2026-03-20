#!/bin/sh
set -eu

if wget -q --spider --timeout=5 https://dl-cdn.alpinelinux.org 2>/dev/null; then
  echo online
  exit 0
fi

echo offline
exit 1
