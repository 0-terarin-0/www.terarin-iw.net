#!/usr/bin/env bash
# R2 の記事と資料を content/ に取得する。jaspr build の前に実行する。
# 使い方: tool/pull_content.sh
set -euo pipefail
source "$(dirname "$0")/_r2.sh"

for dir in blog documents; do
  r2 sync "s3://$R2_BUCKET/$dir" "$root/content/$dir" --exclude '*' --include '*.md' --exclude index.md
done
