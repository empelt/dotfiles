DOT_DIR="$HOME/dotfiles"

# clone
git clone https://github.com/empelt/dotfiles.git ${DOT_DIR}

# link
ln -sf $DOT_DIR/.vimrc ~/.vimrc
