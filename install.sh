#!/bin/bash

DOT_DIR="$HOME/dotfiles"

# clone
git clone https://github.com/empelt/dotfiles.git ${DOT_DIR}
cat ${DOT_DIR}/logo.txt

# tmux
git clone https://github.com/arcticicestudio/nord-tmux.git ~/.tmux/themes/nord-tmux
ln -sf ${DOT_DIR}/tmux/.tmux.conf ~/.tmux.conf

# fish
mkdir -p ~/.config/fish/functions
ln -sf ${DOT_DIR}/fish/config.fish ~/.config/fish/config.fish
ln -sf ${DOT_DIR}/fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish