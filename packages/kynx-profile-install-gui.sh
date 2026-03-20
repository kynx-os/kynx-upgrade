#!/bin/sh
set -eu

mkdir -p /etc/kynx
echo 'install-gui' > /etc/kynx/profile
echo 'Kynx Graphic Install' > /etc/kynx/edition

echo "install-gui profile applied"
