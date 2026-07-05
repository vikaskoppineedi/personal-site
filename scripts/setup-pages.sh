#!/usr/bin/env bash
#
# Provision GitHub Pages for this repo — as code, via gh CLI (no UI click-ops).
# Idempotent: safe to re-run.
#
# Why this exists: with the GitHub Actions deploy model, the custom domain is a
# Pages API setting, NOT a CNAME file (that only works for legacy branch
# deploys). So the domain is declared here as a reproducible command.
#
# Prereqs:
#   - `gh auth login` with admin rights on the repo
#   - DNS already resolving: `vikas` CNAME -> vikaskoppineedi.github.io
#     (managed in homelab-infra/vikas-site-cloudflare.tf)
#
# Usage: ./scripts/setup-pages.sh
set -euo pipefail

REPO="vikaskoppineedi/personal-site"
DOMAIN="vikas.koppineedi.com"

echo "1/3 Enabling Pages (build source = GitHub Actions)…"
gh api -X POST "repos/$REPO/pages" -f build_type=workflow >/dev/null 2>&1 \
  && echo "    enabled." || echo "    already enabled."

echo "2/3 Attaching custom domain $DOMAIN…"
gh api -X PUT "repos/$REPO/pages" -f cname="$DOMAIN" -f build_type=workflow >/dev/null
echo "    attached."

echo "3/3 Enforcing HTTPS (needs the Let's Encrypt cert to be provisioned first)…"
if gh api -X PUT "repos/$REPO/pages" -F https_enforced=true >/dev/null 2>&1; then
  echo "    HTTPS enforced."
else
  echo "    cert not ready yet — re-run this script in a few minutes to enforce HTTPS."
fi

echo "Done. Site: https://$DOMAIN"
