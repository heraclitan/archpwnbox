# ArchPwnBox

A penetration testing environment with BlackArch tools, AUR access, and my custom dotfiles configuration.

## Files

- `Dockerfile`: Container definition.
- `entrypoint.sh`: Container startup script.
- `pacman-packages.txt`: Official repository packages.
- `yay-packages.txt`: AUR packages.
- `pipx-packages.txt`: Python tools.

## Build

```bash
docker build -t archpwnbox:latest .
```

## Run

```bash
docker run -it archpwnbox:latest
```

```bash
docker run -it -v $(pwd)/shared:/home/archuser/shared archpwnbox:latest
```

The `shared` directory is ephemeral and deletes with container removal.

## Features

- BlackArch repository integration.
- Non-root `archuser` with sudo privileges.
- Automatic configuration of my dotfiles.
- Customizable tool selection via package lists.
- Python tool isolation via pipx.
