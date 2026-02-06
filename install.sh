#!/bin/bash
set -e

DOT_DIR="${DOT_DIR:-$HOME/code/dotfiles}"

echo "================================"
echo "  dotfiles installer"
echo "================================"

# OS判定
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if grep -q Microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

OS=$(detect_os)
echo "Detected OS: $OS"

# Clone if not exists
if [ ! -d "$DOT_DIR" ]; then
    git clone https://github.com/empelt/dotfiles.git "$DOT_DIR"
fi

# ===================
# Homebrew
# ===================
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Set up brew environment
    if [ "$OS" = "macos" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# ===================
# macOS
# ===================
install_macos() {
    install_homebrew

    echo "Installing tools (macOS)..."
    brew install starship sheldon fzf direnv mise
    brew install --cask ghostty font-jetbrains-mono-nerd-font

    # Ghostty config
    mkdir -p ~/.config/ghostty
    ln -sf "$DOT_DIR/config/ghostty/config" ~/.config/ghostty/config
}

# ===================
# Linux (Ubuntu)
# ===================
install_linux() {
    echo "Installing dependencies (Linux)..."
    sudo apt update
    sudo apt install -y git curl build-essential zsh

    install_homebrew

    echo "Installing tools (Linux)..."
    brew install starship sheldon fzf direnv mise

    # Nerd Font
    mkdir -p ~/.local/share/fonts
    if [ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
        echo "Installing JetBrains Mono Nerd Font..."
        curl -fLo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
        unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
        fc-cache -fv
        rm /tmp/JetBrainsMono.zip
    fi

    # Alacritty (alternative terminal for Linux)
    if ! command -v alacritty &> /dev/null; then
        echo "Installing Alacritty..."
        sudo apt install -y alacritty || brew install alacritty
    fi

    # Alacritty config
    mkdir -p ~/.config/alacritty
    ln -sf "$DOT_DIR/config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

    # Set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
    fi
}

# ===================
# WSL (Windows)
# ===================
install_wsl() {
    echo "Installing for WSL..."
    install_linux

    echo ""
    echo "NOTE: For Windows Terminal, import the theme from:"
    echo "  $DOT_DIR/config/windows-terminal/settings.json"
}

# ===================
# Common setup
# ===================
setup_common() {
    # Create directories
    mkdir -p ~/.config/sheldon

    # Symlinks
    echo "Creating symlinks..."
    ln -sf "$DOT_DIR/zsh/.zshrc" ~/.zshrc
    ln -sf "$DOT_DIR/zsh/.zprofile" ~/.zprofile
    ln -sf "$DOT_DIR/config/starship.toml" ~/.config/starship.toml
    ln -sf "$DOT_DIR/config/sheldon/plugins.toml" ~/.config/sheldon/plugins.toml

    # Initialize sheldon
    echo "Initializing sheldon plugins..."
    export PATH="$HOME/.local/bin:$PATH"
    if [ "$OS" = "macos" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    sheldon lock
}

# ===================
# Main
# ===================
case "$OS" in
    macos) install_macos ;;
    linux) install_linux ;;
    wsl)   install_wsl ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

setup_common

echo ""
echo "================================"
echo "  Setup complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Create ~/.zshrc.local for machine-specific settings"
if [ "$OS" = "linux" ] || [ "$OS" = "wsl" ]; then
    echo "  3. Use Alacritty as your terminal emulator"
fi
echo ""
