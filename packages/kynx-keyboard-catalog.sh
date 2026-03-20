#!/bin/sh
set -eu

cat << 'EOL'
[
  { "id": "us", "name": "English (US)", "mode": "offline" },
  { "id": "gb", "name": "English (UK)", "mode": "offline" },
  { "id": "ara", "name": "Arabic", "mode": "offline" },
  { "id": "de", "name": "German", "mode": "online" },
  { "id": "fr", "name": "French", "mode": "online" },
  { "id": "tr", "name": "Turkish", "mode": "online" }
]
EOL
