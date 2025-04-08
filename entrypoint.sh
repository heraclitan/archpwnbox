#!/bin/bash

# Run archdawn initialization as the non-root user
if [ -f /home/archuser/init_dotfiles.sh ]; then
    echo "Setting up dotfiles using archdawn..."
    su - archuser -c "/home/archuser/init_dotfiles.sh"
fi

# Install additional dependencies that might be needed for the dotfiles
su - archuser -c "yay -S --noconfirm zsh neovim git"

# Execute the command passed to docker run
exec "$@"
