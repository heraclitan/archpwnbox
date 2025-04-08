# ArchPwnBox

A customized Arch Linux-based Docker container for penetration testing and security research.

## Features

- Built on Arch Linux base
- BlackArch repository pre-configured
- Essential tools pre-installed:
  - `nmap` (via pacman)
  - `seclists` (via yay)
- Automatic dotfiles configuration using the archdawn system
- Non-root user setup with sudo privileges
- AUR support via yay

## Quick Start

### Build the Image

```bash
git clone https://github.com/yourusername/archpwnbox.git
cd archpwnbox
docker build -t archpwnbox .
```

### Run the Container

```bash
docker run -it --rm archpwnbox
```

## Usage

### Basic Operation

- The container has two users:
  - `root` (for system-level operations)
  - `archuser` (for normal usage and AUR packages)
- Your dotfiles will be automatically set up on container start
- BlackArch tools can be installed with: `pacman -S <tool-name>`
- AUR packages can be installed with: `yay -S <package-name>`

### Persistence

To persist data between container restarts:

```bash
docker run -it -v /path/on/host:/home/archuser/data archpwnbox
```

### Network Configuration

For network testing:

```bash
docker run -it --network host archpwnbox
```

## Dotfiles

The container automatically configures dotfiles using the archdawn system:

- Clones the dotfiles repository from GitHub
- Sets up directory structure for configurations
- Links Neovim, Zsh, and shell configurations
- Creates a consistent environment on every container start

## Customization

### Adding More Tools

To add more tools to the base image, modify the Dockerfile:

```dockerfile
# Install additional BlackArch tools
RUN pacman -S --noconfirm metasploit burpsuite wireshark
```

### Using Different Dotfiles

To use different dotfiles, modify the Dockerfile to point to your repository:

```dockerfile
# Clone a different archdawn repository
RUN git clone https://github.com/yourusername/archdawn.git /home/archuser/archdawn
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
