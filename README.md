# dotfiles

macOS 向けの dotfiles

## 含まれる設定

| カテゴリ | 設定ファイル | 説明 |
|----------|--------------|------|
| Shell | `.zshrc` | Oh My Zsh + Powerlevel10k |
| Ghostty | `config` | Dracula テーマ、半透明背景 |
| Zellij | `config.kdl` | カスタムキーバインド |
| Zellij | `layouts/dev.kdl` | 開発用レイアウト (yazi + claude + lazygit) |

## インストール

```bash
git clone https://github.com/tkr53/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh
```

## 依存関係

install.sh が以下を自動インストールします:

- **Homebrew**
- **Ghostty** - ターミナルエミュレータ
- **Zellij** - ターミナルマルチプレクサ
- **Hack Nerd Font** - フォント
- **yazi** - ファイルマネージャー
- **lazygit** - Git TUI
- **Claude Code** - AI CLI
- **Oh My Zsh** - Zsh フレームワーク
- **Powerlevel10k** - Zsh テーマ

## インストール後

```bash
source ~/.zshrc
p10k configure  # Powerlevel10k の初期設定
```
