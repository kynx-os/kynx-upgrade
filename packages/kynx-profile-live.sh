#!/bin/sh
set -eu

mkdir -p /etc/kynx
echo 'live' > /etc/kynx/profile
echo 'Kynx Live' > /etc/kynx/edition

echo "live profile applied"
