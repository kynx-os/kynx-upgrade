#!/bin/sh
set -eu

mkdir -p /etc /usr/lib /usr/share/kynx /usr/share/backgrounds/kynx

cat > /etc/os-release << 'EOL'
NAME="Kynx OS"
ID=kynx
PRETTY_NAME="Kynx OS"
HOME_URL="https://kynx.xyz"
DOCUMENTATION_URL="https://kynx-os.org"
EOL

cat > /usr/lib/os-release << 'EOL'
NAME="Kynx OS"
ID=kynx
PRETTY_NAME="Kynx OS"
HOME_URL="https://kynx.xyz"
DOCUMENTATION_URL="https://kynx-os.org"
EOL

cat > /etc/issue << 'EOL'
Welcome to Kynx OS
Official sites:
https://kynx.xyz
https://kynx-os.org

EOL

cat > /etc/issue.net << 'EOL'
Kynx OS
EOL

cat > /etc/motd << 'EOL'
Kynx OS
EOL

echo 'kynx' > /etc/hostname

mkdir -p /usr/share/kynx/branding
echo 'Kynx OS' > /usr/share/kynx/branding/system-name.txt

echo "branding applied"
