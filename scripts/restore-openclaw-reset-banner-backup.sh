#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-dir>" >&2
  exit 1
fi

BACKUP_DIR="$1"
OPENCLAW_DIST="/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist"

cp -a "$BACKUP_DIR/reply-Deht_wOB.js" "$OPENCLAW_DIST/"
cp -a "$BACKUP_DIR/reply-Duq0R59W.js" "$OPENCLAW_DIST/plugin-sdk/"
cp -a "$BACKUP_DIR/pi-embedded-CQnl8oWA.js" "$OPENCLAW_DIST/"
cp -a "$BACKUP_DIR/pi-embedded-CaI0IFWw.js" "$OPENCLAW_DIST/"
cp -a "$BACKUP_DIR/subagent-registry-CVXe4Cfs.js" "$OPENCLAW_DIST/"

echo "Restored from $BACKUP_DIR"
