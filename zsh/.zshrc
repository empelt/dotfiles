# ============================================
# 1. 基本設定
# ============================================
# Homebrew (cross-platform)
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"

# macOS specific
if [[ "$(uname)" == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
    PATH=~/.console-ninja/.bin:$PATH
fi

# ============================================
# 2. シェルオプション（fish-like動作）
# ============================================
setopt AUTO_CD              # ディレクトリ名だけでcd
setopt AUTO_PUSHD           # cdでディレクトリスタックに追加
setopt CORRECT              # コマンド修正提案
setopt HIST_IGNORE_ALL_DUPS # 履歴の重複削除
setopt SHARE_HISTORY        # 履歴をセッション間で共有

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ============================================
# 3. sheldon（プラグイン）
# ============================================
if command -v sheldon &> /dev/null; then
    eval "$(sheldon source)"
fi

# ============================================
# 4. キーバインド（fish-like）
# ============================================
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^F' autosuggest-accept
bindkey '^[[C' autosuggest-accept

# ============================================
# 5. 補完設定
# ============================================
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# ============================================
# 6. ツール初期化
# ============================================
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ============================================
# 7. エイリアス
# ============================================
alias k='kubectl'

# ============================================
# 8. ローカル設定（gitignore対象）
# ============================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
