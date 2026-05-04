#!/usr/bin/env bash
# Tmux status bar widget: OpenCode Go plan usage [5h/weekly/monthly]
# Computes usage percentages from the local opencode SQLite database.

DB_PATH="$HOME/.local/share/opencode/opencode.db"
CACHE_FILE="/tmp/tmux-opencode-go-usage-cache"
CACHE_TTL=60  # seconds

now=$(date +%s)

if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
    if (( cache_age < CACHE_TTL )); then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

if [[ ! -f "$DB_PATH" ]]; then
    echo "[no db]"
    exit 0
fi

result=$(python3 -c "
import sqlite3, json, time, sys

db_path = '$DB_PATH'
now_ms = int(time.time() * 1000)

# Time windows in milliseconds
five_h_ago   = now_ms - (5 * 3600 * 1000)
seven_d_ago  = now_ms - (7 * 24 * 3600 * 1000)
thirty_d_ago = now_ms - (30 * 24 * 3600 * 1000)

# OpenCode Go plan limits in USD
LIMIT_5H      = 12.0
LIMIT_WEEKLY  = 30.0
LIMIT_MONTHLY = 60.0

conn = sqlite3.connect(db_path)
cur = conn.cursor()

# Query assistant messages that went through opencode-go.
# Fallback chain for timestamp: time.completed -> time.created -> message.time_created
cur.execute('''
    SELECT
        COALESCE(NULLIF(json_extract(m.data, '\$.cost'), 0), 0) as cost,
        COALESCE(
            NULLIF(json_extract(m.data, '\$.time.completed'), 0),
            NULLIF(json_extract(m.data, '\$.time.created'), 0),
            m.time_created
        ) as ts
    FROM message m
    WHERE json_extract(m.data, '\$.role') = 'assistant'
      AND json_extract(m.data, '\$.providerID') = 'opencode-go'
      AND cost > 0
''')

cost_5h = 0.0
cost_weekly = 0.0
cost_monthly = 0.0

for row in cur:
    cost, ts = row
    if not cost or not ts:
        continue

    cost_monthly += cost
    if ts >= seven_d_ago:
        cost_weekly += cost
    if ts >= five_h_ago:
        cost_5h += cost

conn.close()

p5h   = min(100, int(cost_5h   / LIMIT_5H      * 100))
pw    = min(100, int(cost_weekly  / LIMIT_WEEKLY  * 100))
pm    = min(100, int(cost_monthly / LIMIT_MONTHLY * 100))

print(f'[{p5h}%/{pw}%/{pm}%]')
" 2>/dev/null)

if [[ -n "$result" ]]; then
    echo "$result" > "$CACHE_FILE"
    echo "$result"
else
    echo "[err]"
fi
