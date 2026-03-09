#!/usr/bin/env bash
set -euo pipefail

OPENCLAW_DIST="/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="/home/lchych/clawd/backups/openclaw-reset-banner-${STAMP}"
mkdir -p "$BACKUP_DIR" "$(dirname "$OPENCLAW_DIST/plugin-sdk/reply-Duq0R59W.js")"

FILES=(
  "$OPENCLAW_DIST/reply-Deht_wOB.js"
  "$OPENCLAW_DIST/plugin-sdk/reply-Duq0R59W.js"
  "$OPENCLAW_DIST/pi-embedded-CQnl8oWA.js"
  "$OPENCLAW_DIST/pi-embedded-CaI0IFWw.js"
  "$OPENCLAW_DIST/subagent-registry-CVXe4Cfs.js"
)

for f in "${FILES[@]}"; do
  cp -a "$f" "$BACKUP_DIR/"
done

python3 - <<'PY'
from pathlib import Path
files = [
'/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/reply-Deht_wOB.js',
'/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/plugin-sdk/reply-Duq0R59W.js',
'/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/pi-embedded-CQnl8oWA.js',
'/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/pi-embedded-CaI0IFWw.js',
'/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/subagent-registry-CVXe4Cfs.js',
]
old = '''async function sendResetSessionNotice(params) {
\tconst route = resolveResetSessionNoticeRoute({
\t\tctx: params.ctx,
\t\tcommand: params.command
\t});
\tif (!route) return;
\tawait routeReply({
\t\tpayload: { text: buildResetSessionNoticeText({
\t\t\tprovider: params.provider,
\t\t\tmodel: params.model,
\t\t\tdefaultProvider: params.defaultProvider,
\t\t\tdefaultModel: params.defaultModel
\t\t}) },
\t\tchannel: route.channel,
\t\tto: route.to,
\t\tsessionKey: params.sessionKey,
\t\taccountId: params.accountId,
\t\tthreadId: params.threadId,
\t\tcfg: params.cfg
\t});
}'''
new = '''async function sendResetSessionNotice(params) {
\treturn;
}'''
for f in files:
    p = Path(f)
    text = p.read_text(encoding='utf-8')
    if new in text:
        print('already patched', f)
        continue
    if old not in text:
        raise SystemExit(f'replacement target not found in {f}')
    p.write_text(text.replace(old, new, 1), encoding='utf-8')
    print('patched', f)
PY

echo "Patch applied. Backup: $BACKUP_DIR"
