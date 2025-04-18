# ArchPwnBox

A penetration testing environment with BlackArch tools, AUR access, and custom dotfiles configuration.

## Features

- BlackArch repository integration for security tools
- Non-root `archuser` with sudo privileges
- Zsh shell with custom configuration
- Automatic setup of dotfiles during container initialization
- Customizable tool selection via package list files
- Python tool isolation via pipx

## Files

- `Dockerfile`: Container definition and build instructions
- `entrypoint.sh`: Container initialization script
- `pacman-packages.txt`: Official repository packages
- `yay-packages.txt`: AUR packages from the User Repository
- `pipx-packages.txt`: Python tools installed via pipx

## Build

Build the container with:

```bash
docker build -t archpwnbox:latest .
```

## Run

### Basic Usage

Run the container with:

```bash
docker run -it archpwnbox:latest
```

### Using a Shared Directory

To share files between your host and the container:

```bash
docker run -it -v $(pwd)/shared:/home/archuser/shared archpwnbox:latest
```

> **Note**: When running with a shared directory, all data in the container will be lost when the container is removed, but the `shared` directory on your host will persist.

### Zsh Configuration

The container uses Zsh with a custom configuration. To load the custom configuration, run:

```bash
source ~/.config/zsh/.zshrc
```

## Customization

Modify the package list files to customize which tools are installed:

1. Edit `pacman-packages.txt` for official Arch packages
2. Edit `yay-packages.txt` for AUR packages
3. Edit `pipx-packages.txt` for Python tools

## Development

The container uses the archdawn script to set up dotfiles. The script fetches the dotfiles from a repository and links them to appropriate locations.