#!/bin/sh
set -eu

mkdir -p /etc/kynx
echo 'install-tui' > /etc/kynx/profile
echo 'Kynx Text Install' > /etc/kynx/edition

echo "install-tui profile applied"
