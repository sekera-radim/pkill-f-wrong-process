#!/bin/bash
# Starts an unrelated leftover script the same way: a plain background
# process, started by its own absolute path, with its own pid file.
set -euo pipefail
nohup node /home/dev/scratch/api-server.js > /tmp/scratch.log 2>&1 &
echo $! > /tmp/scratch.pid
sleep 0.5
