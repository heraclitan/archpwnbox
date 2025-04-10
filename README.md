## Package Management

### Using the Package Management Script

The included `manage-packages.sh` script helps you manage packages:

```bash
# Add packages to pacman list
./manage-packages.sh -p nmap wireshark

# Add packages to yay/AUR list
./manage-packages.sh -y seclists burpsuite-free

# Remove packages from any list
./manage-packages.sh -r nmap burpsuite-free

# List all current packages
./manage-packages.sh -l
```

This makes it easy to maintain your customized tool list without directly editing the package files.

### Managing Packages in Running Containers

Important: Package list changes only affect newly built images, not running containers.

**Workflow for adding/removing packages:**

1. Modify package lists using the management script or by editing the files directly
2. Rebuild the Docker image:
   ```bash
   docker build -t archpwnbox .
   ```
3. Start a fresh container with the updated package set:
   ```bash
   docker run -it archpwnbox
   ```

**For one-time package installations in a running container:**

You can install packages directly in a running container, but these changes will be lost when the container stops:
```bash
# For official packages
sudo pacman -S package-name

# For AUR packages 
yay -S package-name
```

For persistence, add frequently used packages to the appropriate list files.# ArchPwnBox

A customized Arch Linux-based Docker container for penetration testing and security research.

## Features

- Built on Arch Linux base
- BlackArch repository pre-configured
- Extensive collection of pre-installed security tools:
  - Reconnaissance tools (nmap, wireshark, etc.)
  - Exploitation frameworks (metasploit, etc.)
  - Web application scanners (sqlmap, etc.)
  - Password cracking utilities (hydra, etc.)
  - And many more from both official repos and AUR
- Customizable package lists for both pacman and AUR packages
- Automatic dotfiles configuration using the archdawn system
- Non-root user setup with sudo privileges
- AUR support via yay

## Quick Start

### Setup

1. Create a new directory for the project and place all files in it:
   ```bash
   mkdir -p archpwnbox
   cd archpwnbox
   # Copy all the files into this directory
   ```

2. Make sure you have these files in your directory:
   - `Dockerfile`
   - `entrypoint.sh`
   - `pacman-packages.txt`
   - `yay-packages.txt`
   - `manage-packages.sh` (optional)

### Build the Image

```bash
# From within the archpwnbox directory
docker build -t archpwnbox:latest .
```

### Run the Container

```bash
# Basic usage
docker run -it archpwnbox:latest

# With persistence
docker run -it -v $(pwd)/data:/home/archuser/data archpwnbox:latest
```

## Usage

### Basic Operation

- The container logs in as `archuser` by default (a non-root user with sudo privileges)
- For root access, use `sudo` when needed
- Your dotfiles will be automatically set up on container start
- BlackArch tools can be installed with: `pacman -S <tool-name>` (with sudo)
- AUR packages can be installed with: `yay -S <package-name>` (no sudo needed)

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

### Package Management

The container uses two list files to manage packages:

- `pacman-packages.txt`: For official repository packages (installed with pacman)
- `yay-packages.txt`: For AUR packages (installed with yay)

To add or remove packages, simply edit these files before building the container. Each file supports:
- One package per line
- Comments (lines starting with #)
- Blank lines for organization

Example:
```
# Security tools
nmap
metasploit

# Utilities
htop
```

### Adding More Tools

To add tools beyond the package lists, modify the Dockerfile:

```dockerfile
# Install additional tools with custom commands
RUN git clone https://github.com/example/tool.git && \
    cd tool && \
    make install
```

### Using Different Dotfiles

To use different dotfiles, modify the Dockerfile to point to your repository:

```dockerfile
# Clone a different archdawn repository
RUN git clone https://github.com/yourusername/archdawn.git /home/archuser/archdawn
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
