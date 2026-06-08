#!/usr/bin/env bash
# Add resume-kit plugin to ~/.claude/settings.json.
# Run manually on machines where you want resume-kit available.
#
# Usage: bash claude/optional/add-resume-kit.sh [/path/to/resume-kit]
#
# Default path: ~/resume-kit  (clone it there first if needed)
#   git clone git@github.com:nawtrobar/resume-kit.git ~/resume-kit
set -euo pipefail

PLUGIN_PATH="${1:-$HOME/resume-kit}"
SETTINGS="$HOME/.claude/settings.json"

if [ ! -d "$PLUGIN_PATH" ]; then
  echo "[error] resume-kit not found at: $PLUGIN_PATH"
  echo "        Clone it first: git clone git@github.com:nawtrobar/resume-kit.git $PLUGIN_PATH"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "[error] jq is required. Install with: sudo apt-get install -y jq"
  exit 1
fi

if [ ! -f "$SETTINGS" ]; then
  echo "[error] ~/.claude/settings.json not found. Run install.sh first."
  exit 1
fi

# Idempotent — skip if already present
if jq -e '.extraKnownMarketplaces["resume-kit"]' "$SETTINGS" &>/dev/null; then
  echo "[ok] resume-kit already configured in $SETTINGS"
  exit 0
fi

tmp=$(mktemp)
jq \
  --arg path "$PLUGIN_PATH" \
  '.enabledPlugins["resume-kit@resume-kit"] = true
   | .extraKnownMarketplaces["resume-kit"] = {
       "source": { "source": "directory", "path": $path }
     }' \
  "$SETTINGS" > "$tmp"
mv "$tmp" "$SETTINGS"

echo "[ok] resume-kit added to ~/.claude/settings.json (path: $PLUGIN_PATH)"
echo "     Restart Claude Code to pick it up."
