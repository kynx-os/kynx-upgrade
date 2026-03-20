#!/bin/sh
set -eu

APP="${1:-}"
APP_BASE="/opt/kynx/apps"

if [ -z "$APP" ]; then
  echo "usage: kynx-app-install <app-id>"
  exit 1
fi

APP_ROOT="$APP_BASE/$APP"

if [ ! -d "$APP_ROOT" ]; then
  echo "app not found: $APP"
  exit 1
fi

case "$APP" in
  terminal-gui)
    install -m 0755 "$APP_ROOT/files/kynx-terminal-gui" /usr/bin/kynx-terminal-gui

    mkdir -p /usr/share/applications
    cat > /usr/share/applications/kynx-terminal-gui.desktop << 'EOD'
[Desktop Entry]
Type=Application
Name=Kynx Terminal GUI
Exec=/usr/bin/kynx-terminal-gui
Terminal=false
Categories=System;Utility;
StartupNotify=true
EOD
    chmod 644 /usr/share/applications/kynx-terminal-gui.desktop
    ;;
  *)
    echo "unsupported app: $APP"
    exit 1
    ;;
esac

echo "installed: $APP"
