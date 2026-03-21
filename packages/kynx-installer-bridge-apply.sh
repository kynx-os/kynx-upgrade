#!/bin/sh
set -eu

apk add --no-cache python3

mkdir -p /usr/bin /var/log

cat > /usr/bin/kynx-installer-bridge << 'EOL'
#!/usr/bin/env python3
import json
import os
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

HOST = "127.0.0.1"
PORT = 8090
LOG_PATH = "/var/log/kynx-install.log"

def run(cmd: str):
    p = subprocess.run(
        ["sh", "-lc", cmd],
        capture_output=True,
        text=True,
    )
    return p.returncode, p.stdout, p.stderr

def json_ok(handler, payload, status=200):
    data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    handler.send_response(status)
    handler.send_header("Content-Type", "application/json; charset=utf-8")
    handler.send_header("Content-Length", str(len(data)))
    handler.end_headers()
    handler.wfile.write(data)

def read_json_script(cmd: str):
    code, out, err = run(cmd)
    if code != 0:
        return {"ok": False, "error": err.strip() or out.strip() or "command failed"}
    try:
        return {"ok": True, "data": json.loads(out)}
    except Exception as e:
        return {"ok": False, "error": f"invalid json: {e}"}

def parse_disks():
    code, out, err = run("kynx-installer-core probe")
    if code != 0:
        return {"ok": False, "error": err.strip() or out.strip() or "probe failed"}

    disks = []
    for line in out.splitlines():
        line = line.strip()
        if not line or line.startswith("Available target disks:"):
            continue
        disks.append({
            "id": line,
            "name": line,
            "currentSystem": line == "/dev/vda",
        })
    return {"ok": True, "data": disks}

def config_summary():
    code, out, err = run("kynx-installer-config summary")
    if code != 0 and out.strip() == "" and err.strip() == "":
        return {"ok": True, "data": {}}
    if code != 0:
        return {"ok": False, "error": err.strip() or out.strip() or "summary failed"}

    data = {}
    for line in out.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            data[k.strip()] = v.strip()
    return {"ok": True, "data": data}

class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path
        qs = parse_qs(parsed.query)

        if path == "/api/ping":
            return json_ok(self, {"ok": True, "message": "kynx installer bridge running"})

        if path == "/api/disks":
            return json_ok(self, parse_disks())

        if path == "/api/desktops":
            return json_ok(self, read_json_script("kynx-desktop-catalog"))

        if path == "/api/regions":
            return json_ok(self, read_json_script("kynx-region-catalog"))

        if path == "/api/languages":
            return json_ok(self, read_json_script("kynx-language-catalog"))

        if path == "/api/keyboards":
            return json_ok(self, read_json_script("kynx-keyboard-catalog"))

        if path == "/api/network/status":
            code, _, _ = run("kynx-net-check")
            return json_ok(self, {"ok": True, "data": {"online": code == 0}})

        if path == "/api/config/summary":
            return json_ok(self, config_summary())

        if path == "/api/config/set":
            key = (qs.get("key") or [""])[0].strip()
            value = (qs.get("value") or [""])[0]
            if not key:
                return json_ok(self, {"ok": False, "error": "missing key"}, 400)

            code, out, err = run(f'kynx-installer-config set "{key}" "{value}"')
            if code != 0:
                return json_ok(self, {"ok": False, "error": err.strip() or out.strip() or "set failed"}, 500)
            return json_ok(self, {"ok": True, "message": out.strip()})

        if path == "/api/install/start":
            disk = (qs.get("disk") or [""])[0].strip()
            if not disk:
                return json_ok(self, {"ok": False, "error": "missing disk"}, 400)

            run(f': > "{LOG_PATH}"')
            cmd = f'nohup sh -lc \'kynx-installer-core apply-v2 "{disk}" --yes > "{LOG_PATH}" 2>&1\' >/dev/null 2>&1 &'
            code, out, err = run(cmd)
            if code != 0:
                return json_ok(self, {"ok": False, "error": err.strip() or out.strip() or "failed to start install"}, 500)

            return json_ok(self, {"ok": True, "message": f"installation started for {disk}"})

        if path == "/api/install/log":
            if not os.path.exists(LOG_PATH):
                return json_ok(self, {"ok": True, "data": {"log": ""}})
            with open(LOG_PATH, "r", encoding="utf-8", errors="ignore") as f:
                return json_ok(self, {"ok": True, "data": {"log": f.read()}})

        return json_ok(self, {"ok": False, "error": "not found"}, 404)

httpd = HTTPServer((HOST, PORT), Handler)
print(f"Kynx Installer Bridge listening on http://{HOST}:{PORT}")
httpd.serve_forever()
EOL

chmod +x /usr/bin/kynx-installer-bridge

cat > /usr/bin/kynx-installer-bridge-start << 'EOL'
#!/bin/sh
set -eu
pkill -f "python3 /usr/bin/kynx-installer-bridge" 2>/dev/null || true
nohup /usr/bin/kynx-installer-bridge >/tmp/kynx-installer-bridge.log 2>&1 &
echo "bridge started"
EOL

chmod +x /usr/bin/kynx-installer-bridge-start

echo "installer bridge applied"
