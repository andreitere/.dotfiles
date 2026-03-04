#!/usr/bin/env bash
# Tmux status bar widget: Claude Code usage (5h window + 7d weekly)
# Calls the Anthropic OAuth usage API with caching

CACHE_FILE="/tmp/tmux-claude-usage-cache"
CACHE_TTL=60  # seconds
CREDS_FILE="$HOME/.claude/.credentials.json"

now=$(date +%s)

if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
    if (( cache_age < CACHE_TTL )); then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

if [[ ! -f "$CREDS_FILE" ]]; then
    echo "no auth"
    exit 0
fi

TOKEN=$(python3 -c "import json; print(json.load(open('$CREDS_FILE'))['claudeAiOauth']['accessToken'])" 2>/dev/null)

if [[ -z "$TOKEN" ]]; then
    echo "no token"
    exit 0
fi

RESP=$(curl -sf "https://api.anthropic.com/api/oauth/usage" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)

if [[ -z "$RESP" ]]; then
    echo "API err"
    exit 0
fi

result=$(python3 -c "
import json, sys
d = json.loads('''$RESP''')
h5 = d.get('five_hour', {}).get('utilization', 0) or 0
d7 = d.get('seven_day', {}).get('utilization', 0) or 0
print(f'5h:{h5:.0f}% 7d:{d7:.0f}%')
" 2>/dev/null)

if [[ -n "$result" ]]; then
    echo "$result" > "$CACHE_FILE"
    echo "$result"
else
    echo "parse err"
fi
