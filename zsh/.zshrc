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
# 2. SSL/TLS設定
# ============================================
if [ -n "$HOMEBREW_PREFIX" ]; then
    export MY_CUSTOM_CA_PATH="$HOMEBREW_PREFIX/etc/openssl@3/certs"
    export MY_CUSTOM_CA_FILE="$MY_CUSTOM_CA_PATH/palo-root.pem"
    export SSL_CERT_DIR="$MY_CUSTOM_CA_PATH"
    export CAPATH="$MY_CUSTOM_CA_PATH"
    export NODE_EXTRA_CA_CERTS="$MY_CUSTOM_CA_FILE"
    export REQUESTS_CA_BUNDLE="$MY_CUSTOM_CA_FILE"
    export CURL_CA_BUNDLE="$MY_CUSTOM_CA_FILE"
    export AWS_CA_BUNDLE="$HOMEBREW_PREFIX/etc/ca-certificates/cert.pem"
fi

# ============================================
# 3. シェルオプション（fish-like動作）
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
# 4. sheldon（プラグイン）
# ============================================
if command -v sheldon &> /dev/null; then
    eval "$(sheldon source)"
fi

# ============================================
# 5. キーバインド（fish-like）
# ============================================
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^F' autosuggest-accept
bindkey '^[[C' autosuggest-accept

# ============================================
# 6. 補完設定
# ============================================
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# ============================================
# 7. ツール初期化
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
# 8. エイリアス
# ============================================
alias k='kubectl'

# ============================================
# 9. ローカル設定（gitignore対象）
# ============================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
