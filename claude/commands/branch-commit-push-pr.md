---
allowed-tools: Bash, Read, Grep
description: ブランチ作成→コミット→プッシュ→PR作成を一括実行
---

# ブランチ切ってコミット・プッシュ・PR作成

現在の変更差分からブランチ作成、コミット、プッシュ、PR作成までを一括で行う。

## 手順

1. `git status` と `git diff --stat` と `git log --oneline -5` を並列実行し、現在の状態を把握する
2. `.github/pull_request_template.md` が存在するか確認する（Readツールで読む）
3. 変更内容を分析し、以下を決定する:
   - ブランチ名（Conventional Commits形式のプレフィックス: feature/, fix/, refactor/ など）
   - コミットメッセージ（Conventional Commits形式、日本語で体言止め）
   - PRタイトルとサマリー
4. ユーザーに以下を確認する（AskUserQuestion）:
   - ブランチ名
   - コミットメッセージ
   - ベースブランチ（デフォルト: main）
5. 承認後、以下を順次実行:
   - `git checkout -b <ブランチ名>`
   - 対象ファイルを `git add`（.env, credentials等の機密ファイルは除外）
   - `git commit`（HEREDOCでメッセージ指定、Co-Authored-By付き）
   - `git push -u origin <ブランチ名>`
   - `gh pr create`（PRテンプレートがあればその形式に従ってbodyを作成、なければSummary + Test plan形式）
6. PR URLを表示する

## PRテンプレートの扱い

- リポジトリルートから `.github/pull_request_template.md` を探す
- テンプレートが存在する場合、そのセクション構成に従ってPR bodyを作成する
- テンプレート内のプレースホルダー（`***` や説明文）は変更内容に基づいて埋める
- Jira Ticket等の情報が不明な場合はプレースホルダーのまま残す
- テンプレートが存在しない場合は、デフォルトのSummary + Test plan形式を使う

## 注意事項

- `git add -A` は使わない。変更ファイルを個別に指定する
- .env, credentials, 機密ファイルはステージングしない
- コミットメッセージのCo-Authored-Byを必ず含める
- PRのbodyはHEREDOCで渡す
- 不明点があれば推測せず質問する
