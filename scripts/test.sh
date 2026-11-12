#!/bin/bash
set -euo pipefail
n=0
pass() { n=$((n+1)); echo "ok $n - $1"; }
fail() { echo "not ok - $1"; exit 1; }

# 1. the real app server comes up
bash ~/scripts/start-app.sh
curl -sf localhost:3000 | grep -q '"ok":true' && pass "app server answers" || fail "app server did not answer"

# 2. an unrelated process is running, sharing the same filename elsewhere
bash ~/scripts/start-scratch.sh
pgrep -af api-server.js | grep -q scratch && pass "unrelated scratch process is running" || fail "scratch process missing"

# 3. a loose pkill -f kills both, even though the pattern looked specific
pkill -f api-server.js
sleep 1
if curl -sf localhost:3000 >/dev/null 2>&1; then fail "app server should be dead"; else pass "a loose pkill -f also killed the app server"; fi
if pgrep -f api-server.js >/dev/null 2>&1; then fail "scratch process should be dead too"; else pass "and the unrelated scratch process too"; fi

# 4. fix: kill by a recorded pid, no pattern involved
bash ~/scripts/start-app.sh
bash ~/scripts/start-scratch.sh
kill "$(cat /tmp/scratch.pid)"
sleep 0.5
curl -sf localhost:3000 | grep -q '"ok":true' && pass "killing by a recorded pid left the app server alone" || fail "app server was affected"

# 5. fix: anchor the pattern to the one full command line you mean
bash ~/scripts/start-scratch.sh
pkill -f "^node /home/dev/scratch/api-server.js$"
sleep 0.5
curl -sf localhost:3000 | grep -q '"ok":true' && pass "an anchored pattern also left the app server alone" || fail "anchored pattern killed the app server"

echo "ALL PASSED"
