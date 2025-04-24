# ArchPwnBox

A penetration testing environment with BlackArch tools, AUR access, and custom dotfiles.

## Features

- BlackArch repository integration
- Non-root `archuser` with sudo privileges
- Zsh shell with custom configuration
- Python tool isolation via pipx

## Usage

Build the container:
```bash
docker build -t archpwnbox:latest .
```

Run the container:
```bash
docker run -it archpwnbox:latest
```

Share files with host:
```bash
docker run -it -v $(pwd)/shared:/home/archuser/shared archpwnbox:latest
```

After starting the container, load Zsh configuration:
```bash
source ~/.config/zsh/.zshrc
```

## Customization

Modify package lists to customize tools:
- `pacman-packages.txt`: Official Arch packages
- `yay-packages.txt`: AUR packages
- `pipx-packages.txt`: Python tools
