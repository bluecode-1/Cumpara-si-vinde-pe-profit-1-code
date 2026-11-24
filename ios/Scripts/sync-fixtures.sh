#!/usr/bin/env bash
# Copies the shared, cross-platform reference files into the Swift package:
#   api/fixtures/*.json -> FakeAPI resources and NetworkingTests resources
#   design/tokens.json  -> DesignSystemTests resources (token parity test)
#   design/fonts/*      -> DesignSystem resources (Manrope + OFL licence)
#
# Usage:
#   Scripts/sync-fixtures.sh          copy the files
#   Scripts/sync-fixtures.sh --check  fail if the copies differ from the sources (CI)
set -euo pipefail

IOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$IOS_DIR/.." && pwd)"
PKG_DIR="$IOS_DIR/Packages/ProfitNetKit"

FIXTURES_SRC="$REPO_DIR/api/fixtures"
FONTS_SRC="$REPO_DIR/design/fonts"
TOKENS_SRC="$REPO_DIR/design/tokens.json"

FIXTURE_DESTS=(
  "$PKG_DIR/Sources/FakeAPI/Fixtures"
  "$PKG_DIR/Tests/NetworkingTests/Fixtures"
)
FONTS_DEST="$PKG_DIR/Sources/DesignSystem/Resources/Fonts"
TOKENS_DEST="$PKG_DIR/Tests/DesignSystemTests/Tokens"

MODE="${1:-sync}"

if [ "$MODE" = "--check" ]; then
  status=0
  for dest in "${FIXTURE_DESTS[@]}"; do
    diff -rq "$FIXTURES_SRC" "$dest" || status=1
  done
  diff -rq "$FONTS_SRC" "$FONTS_DEST" || status=1
  diff -q "$TOKENS_SRC" "$TOKENS_DEST/tokens.json" || status=1
  if [ "$status" -ne 0 ]; then
    echo "Shared files are out of date. Run ios/Scripts/sync-fixtures.sh" >&2
  fi
  exit "$status"
fi

for dest in "${FIXTURE_DESTS[@]}"; do
  mkdir -p "$dest"
  rm -f "$dest"/*.json
  cp "$FIXTURES_SRC"/*.json "$dest"/
done

mkdir -p "$FONTS_DEST"
rm -f "$FONTS_DEST"/*
cp "$FONTS_SRC"/* "$FONTS_DEST"/

mkdir -p "$TOKENS_DEST"
cp "$TOKENS_SRC" "$TOKENS_DEST/tokens.json"

echo "Synced fixtures, fonts and tokens into $PKG_DIR"
