#!/bin/bash

# Run archdawn initialization
if [ -f /home/archuser/init_dotfiles.sh ]; then
    echo "Setting up dotfiles using archdawn..."
    /home/archuser/init_dotfiles.sh
fi

# Install additional dependencies that might be needed for the dotfiles
yay -S --noconfirm zsh neovim git 2>/dev/null || echo "Packages already installed or not available"

# Execute the command passed to docker run
exec "$@"