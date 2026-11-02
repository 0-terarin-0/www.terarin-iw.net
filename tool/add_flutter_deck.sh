#!/usr/bin/env bash
# flutter_deck プロジェクトを Web ビルドして R2 の decks/<slug>/ に配置する。
# 使い方: tool/add_flutter_deck.sh <flutter_deckプロジェクトのパス> <slug>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "usage: $0 <path-to-flutter-deck-project> <slug>" >&2
  exit 1
fi

source "$(dirname "$0")/_r2.sh"

project=$1
slug=$2

(cd "$project" && flutter build web --release --base-href "/decks/$slug/")
r2 sync "$project/build/web" "s3://$R2_BUCKET/decks/$slug" --delete

echo "配置しました: decks/$slug"
echo "content/documents/$slug.md に type: flutter_deck と src: /decks/$slug/index.html を書いてください。"
