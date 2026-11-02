#!/usr/bin/env bash
# content/ の記事と資料を R2 にアップロードする。R2 側のファイルは削除しない。
# 使い方: tool/push_content.sh
set -euo pipefail
source "$(dirname "$0")/_r2.sh"

for dir in blog documents; do
  r2 sync "$root/content/$dir" "s3://$R2_BUCKET/$dir" --exclude '*' --include '*.md' --exclude index.md
done
