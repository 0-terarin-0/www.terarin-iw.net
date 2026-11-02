# www.terarin-iw.net

Koki Teramoto の個人サイトです。プロフィール・ブログ・資料を [Jaspr](https://jaspr.site) と
[jaspr_content](https://docs.jaspr.site/content) で静的サイトとして生成します。

| URL | 内容 | 元ファイル |
| --- | --- | --- |
| `/` | プロフィール | `lib/pages/home_page.dart` |
| `/blog` | ブログ | R2 の `blog/*.md` |
| `/documents` | 資料 | R2 の `documents/*.md` |

記事と資料は Git に入れず、Cloudflare R2 に置きます。ビルドの前に `content/` へ取得するので、公開されるサイトは静的なままです。

## 開発

```bash
dart pub global activate jaspr_cli  # 初回のみ
jaspr serve                         # http://localhost:8080
jaspr build                         # build/jaspr に静的ファイルを出力
```

## R2 の構成

```
<bucket>/
├── blog/<slug>.md            ブログ
├── documents/<slug>.md       資料の説明
└── decks/<slug>/slide.pdf    資料の本体
```

バケットは公開設定にして、`content/_data/site.yaml` の `filesUrl` のドメインを割り当てます。スクリプトには `aws` CLI と、次の環境変数が必要です。

```bash
export R2_ACCOUNT_ID=...
export R2_BUCKET=...
export AWS_ACCESS_KEY_ID=...      # R2 の API トークン
export AWS_SECRET_ACCESS_KEY=...
```

```bash
tool/pull_content.sh   # R2 から content/ に取得
tool/push_content.sh   # content/ から R2 にアップロード（R2 側は削除しない）
```

`content/` の `index.md` だけは Git で管理します。それ以外の `.md` は Git に入らないので、R2 が唯一の保管場所になります。記事を更新したら、サイトの再ビルドが必要です。

## 多言語対応

URL は言語で分けません。初期表示は英語で、ヘッダーの地球儀メニューで切り替えると、選んだ言語がブラウザに保存されます。

- **言語の追加:** `lib/i18n/languages/` に言語ごとのファイルを作り、`lib/i18n/i18n.dart` の `SiteLocale` に1行足します。メニューと CSS は一覧から自動で作られます。アラビア語のような右から左の言語は `isRtl: true` にすると、レイアウトも反転します。その場合は `theme.dart` にその言語のフォントも足してください。
- **機械翻訳の表記:** 各言語の `isMachineTranslated` が `true` の間、全ページに注意書きが出ます。その言語の話者が確認したら `false` にしてください。
- **UI の文言:** 各言語のファイルにあります。項目を追加するときは `lib/i18n/language.dart` の `Messages` に足します。すべての言語で指定するまでコンパイルが通りません。
- **タイトルと説明文:** frontmatter に `title_en` や `description_en` のように `<項目>_<言語コード>` を足します。訳がない言語では元の値を表示します。
- **記事の本文:** 翻訳の仕組みはなく、書いた言語のまま表示されます。

## ブログを書く

`content/blog/<slug>.md` を書いて `tool/push_content.sh` でアップロードすると、次のビルドで `/blog/<slug>` に公開され、一覧にも載ります。一覧は `date` の新しい順です。記事の画像は R2 に置いて、`https://storage1.terarin-iw.net/...` の URL で参照します。

```markdown
---
layout: post
title: 記事タイトル
date: 2026-10-31
description: 一覧に出る説明文
tags: [Flutter, Dart]
---

本文
```

シンタックスハイライトは Dart のみ対応です。他の言語のコードブロックはハイライトなしで表示されます。

## 資料を追加する

`content/documents/<slug>.md` を書いて `tool/push_content.sh` でアップロードすると、次のビルドで `/documents/<slug>` に公開されます。ファイル本体は R2 の `decks/<slug>/` に置きます。`/` で始まる `src` と `download` は `filesUrl` からの URL になります。

```markdown
---
layout: document
title: 資料タイトル
date: 2026-10-31
event: イベント名        # 省略可
description: 説明文      # 省略可
type: pdf
src: /decks/<slug>/slide.pdf
download: /decks/<slug>/slide.pdf  # 省略可
---

補足や参考リンク（Markdown）
```

| `type` | 用途 | `src` |
| --- | --- | --- |
| `pdf` | PDF（`.key` などは PDF に書き出す） | `/decks/<slug>/slide.pdf` |
| `pptx` | PowerPoint | `/decks/<slug>/slide.pptx` |
| `flutter_deck` | flutter_deck の Web ビルド | `/decks/<slug>/index.html` |
| `embed` | Google スライド、Speaker Deck など | サービスの埋め込み URL |

`pptx` は Microsoft の Office Online ビューアで表示するため、公開後の URL からしか表示できません。ローカルでは
プレビューできないので、確実に見せたい資料は PDF も `download` に置いてください。

flutter_deck はこのスクリプトでビルドと R2 への配置ができます。

```bash
tool/add_flutter_deck.sh ../my_deck my-deck
```

## ライセンス

コードは [MIT License](LICENSE) です。プロフィールや記事の文章、画像、ロゴはライセンスの対象外で、著作権は各権利者に帰属します。
