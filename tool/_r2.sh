# tool/ のスクリプトが読み込む R2 の共通設定。
# 必要な環境変数: R2_ACCOUNT_ID, R2_BUCKET, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
: "${R2_ACCOUNT_ID:?R2_ACCOUNT_ID を設定してください}"
: "${R2_BUCKET:?R2_BUCKET を設定してください}"
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID を設定してください}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY を設定してください}"

# 新しい AWS CLI の既定のチェックサムは R2 が対応していない。
export AWS_REQUEST_CHECKSUM_CALCULATION=when_required
export AWS_RESPONSE_CHECKSUM_VALIDATION=when_required

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

r2() {
  aws s3 "$@" --endpoint-url "https://$R2_ACCOUNT_ID.r2.cloudflarestorage.com" --region auto
}
