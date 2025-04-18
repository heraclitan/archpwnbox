#!/bin/bash

# Run archdawn initialization
if [ -f /home/archuser/init_dotfiles.sh ]; then
    echo "Setting up dotfiles using archdawn..."
    /home/archuser/init_dotfiles.sh
fi

# Display instructions
cat << 'EOF'
===========================================================
 Welcome to archpwnbox!
===========================================================

Your dotfiles have been set up.
To load your Zsh configuration, please run:

    source ~/.config/zsh/.zshrc

===========================================================
EOF

# Execute whatever command was passed
exec "$@"