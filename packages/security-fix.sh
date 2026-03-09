#!/bin/sh
set -eu

echo "=== Kynx Security Fix ==="

if [ -d /var/cache/apk ]; then
    rm -rf /var/cache/apk/* 2>/dev/null || true
    echo "APK cache cleaned."
fi

if command -v update-ca-certificates >/dev/null 2>&1; then
    update-ca-certificates >/dev/null 2>&1 || true
    echo "CA certificates refreshed."
fi

if [ -d /etc/kynx ]; then
    chmod 755 /etc/kynx 2>/dev/null || true
    find /etc/kynx -type f -exec chmod 644 {} \; 2>/dev/null || true
    echo "/etc/kynx permissions normalized."
fi

echo "Security maintenance completed."
echo "==========================="
