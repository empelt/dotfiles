# dotfiles

Zsh + Starship のクロスプラットフォーム開発環境設定

## 対応OS

| OS | ターミナル | 状態 |
|----|-----------|------|
| macOS | Ghostty | ✅ |
| Ubuntu/Linux | Alacritty | ✅ |
| Windows (WSL) | Windows Terminal + Alacritty | ✅ |

## 含まれるもの

- **Zsh** - fish-like な操作感 (autosuggestions, syntax-highlighting, fzf-tab)
- **Starship** - カスタマイズ可能なプロンプト
- **Sheldon** - Zsh プラグインマネージャー
- **ターミナル設定** - Ghostty (macOS) / Alacritty (Linux) / Windows Terminal

## インストール

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/empelt/dotfiles/main/install.sh)"
```

または手動で:

```bash
git clone https://github.com/empelt/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

## 構成

```
dotfiles/
├── zsh/
│   ├── .zshrc
│   └── .zprofile
├── config/
│   ├── ghostty/config        # macOS
│   ├── alacritty/alacritty.toml  # Linux/WSL
│   ├── windows-terminal/settings.json  # WSL
│   ├── starship.toml
│   └── sheldon/plugins.toml
├── install.sh
└── README.md
```

## マシン固有の設定

シークレットやマシン固有の設定は `~/.zshrc.local` に記述してください（gitignore対象）。

```bash
# ~/.zshrc.local の例
export JIRA_API_TOKEN='xxx'
alias memo='code ~/memo'
```

## インストールされるツール

| ツール | 用途 | macOS | Linux | WSL |
|--------|------|-------|-------|-----|
| starship | プロンプト | ✅ | ✅ | ✅ |
| sheldon | Zsh プラグイン管理 | ✅ | ✅ | ✅ |
| fzf | ファジー検索 | ✅ | ✅ | ✅ |
| direnv | ディレクトリ別環境変数 | ✅ | ✅ | ✅ |
| mise | ランタイムバージョン管理 | ✅ | ✅ | ✅ |
| ghostty | ターミナル | ✅ | - | - |
| alacritty | ターミナル | - | ✅ | ✅ |
| Nerd Font | フォント | ✅ | ✅ | ✅ |

## Windows (WSL) の追加設定

1. [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) を Windows にインストール
2. Windows Terminal の設定に `config/windows-terminal/settings.json` の内容をマージ
