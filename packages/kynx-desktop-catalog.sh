#!/bin/sh
set -eu

cat << 'EOL'
[
  {
    "id": "minimal",
    "name": "Minimal Desktop",
    "mode": "offline",
    "available": true,
    "description": "Fastest and lightest option."
  },
  {
    "id": "xfce",
    "name": "XFCE Desktop",
    "mode": "offline",
    "available": true,
    "description": "Included with installer. Recommended for offline installs."
  },
  {
    "id": "gnome",
    "name": "GNOME Desktop",
    "mode": "online",
    "available": true,
    "description": "Requires internet during installation."
  },
  {
    "id": "kde",
    "name": "KDE Plasma Desktop",
    "mode": "online",
    "available": true,
    "description": "Requires internet during installation."
  }
]
EOL
