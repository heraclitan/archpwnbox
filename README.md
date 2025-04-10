# ArchPwnBox

An Arch Linux-based Docker container for penetration testing with BlackArch tools, AUR support via yay, and automatic configuration using heraclitan's dotfiles.

## Setup & Usage

### Required Files
- `Dockerfile`
- `entrypoint.sh`
- `pacman-packages.txt` - List of official repo packages
- `yay-packages.txt` - List of AUR packages

### Build
```bash
# From the directory containing your files
docker build -t archpwnbox:latest .
```

### Run
```bash
# Basic usage
docker run -it archpwnbox:latest

# With host networking (for network tools)
docker run -it --network host archpwnbox:latest

# With persistent storage
docker run -it -v $(pwd)/data:/home/archuser/data archpwnbox:latest
```

## Key Features
- Runs as non-root `archuser` with sudo access
- BlackArch repository pre-configured
- Custom tool selection through package lists
- Automatic setup of heraclitan's dotfiles via archdawn

## Managing Tools

### Using Package Lists
Edit these files before building:
- `pacman-packages.txt` - Official repository tools
- `yay-packages.txt` - AUR packages

### Package Management Script
```bash
# Add tools to lists
./manage-packages.sh -p <package-name>   # Add to pacman list
./manage-packages.sh -y <package-name>   # Add to yay list

# Remove tools from lists
./manage-packages.sh -r <package-name>   # Remove from either list

# List all packages
./manage-packages.sh -l
```

## Inside the Container
- BlackArch tools: `sudo pacman -S <tool-name>`
- AUR packages: `yay -S <package-name>`
- heraclitan's dotfiles are automatically configured at startup
