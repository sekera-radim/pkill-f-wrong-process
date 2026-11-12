#!/bin/bash
# Starts the real app server as a plain background process (no service
# manager, no systemd) and waits until it actually answers.
set -euo pipefail
nohup node /home/dev/app/api-server.js > /tmp/api-server.log 2>&1 &
echo $! > /tmp/app.pid
for i in $(seq 1 20); do
  curl -sf localhost:3000 >/dev/null 2>&1 && exit 0
  sleep 0.2
done
echo "api-server did not come up" >&2
exit 1
