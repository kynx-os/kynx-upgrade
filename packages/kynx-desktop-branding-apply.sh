#!/bin/sh
set -eu

mkdir -p \
  /usr/share/kynx/branding \
  /usr/share/icons/hicolor/256x256/apps \
  /usr/share/backgrounds/kynx \
  /usr/share/applications \
  /home/kynx/Desktop

# system name marker
echo 'Kynx OS' > /usr/share/kynx/branding/system-name.txt

# copy known branding assets if present
[ -f /usr/share/kynx/branding/logo.png ] || true
[ -f /usr/share/backgrounds/kynx/default.jpg ] || true

# desktop entries for profile launch points
cat > /usr/share/applications/kynx-live.desktop << 'EOL'
[Desktop Entry]
Type=Application
Name=Kynx Live
Exec=sh -c 'rofi -show drun'
Terminal=false
Categories=System;Utility;
StartupNotify=true
EOL

cat > /usr/share/applications/kynx-graphic-install.desktop << 'EOL'
[Desktop Entry]
Type=Application
Name=Kynx Graphic Install
Exec=/usr/bin/kynx-installer-gui-launcher
Terminal=false
Categories=System;Utility;
StartupNotify=true
EOL

cat > /usr/share/applications/kynx-text-install.desktop << 'EOL'
[Desktop Entry]
Type=Application
Name=Kynx Text Install
Exec=/usr/bin/kynx-installer-tui-launcher
Terminal=true
Categories=System;Utility;
StartupNotify=true
EOL

# desktop shortcuts
cp -f /usr/share/applications/kynx-live.desktop /home/kynx/Desktop/Kynx-Live.desktop
cp -f /usr/share/applications/kynx-graphic-install.desktop /home/kynx/Desktop/Kynx-Graphic-Install.desktop
cp -f /usr/share/applications/kynx-text-install.desktop /home/kynx/Desktop/Kynx-Text-Install.desktop

chmod 755 /home/kynx/Desktop/*.desktop
chown -R kynx:kynx /home/kynx/Desktop 2>/dev/null || true

echo "desktop branding applied"
