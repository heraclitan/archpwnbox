#!/bin/bash

# Run archdawn initialization
if [ -f /home/archuser/init_dotfiles.sh ]; then
    echo "Setting up dotfiles using archdawn..."
    /home/archuser/init_dotfiles.sh
fi

# Print clear instructions for the user
cat << 'EOF'

===========================================================
 Welcome to archpwnbox!
===========================================================

Your dotfiles have been set up.
To load your Zsh configuration, please run:

    source ~/.config/zsh/.zshrc

You may want to add this to your startup routine.
===========================================================

EOF

# Execute the command passed to docker run
if [ $# -eq 0 ]; then
    exec /bin/zsh
else
    exec "$@"
fi