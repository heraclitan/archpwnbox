# ArchPwnBox: A Modular Arch Linux Docker Environment

![Build Status](https://img.shields.io/badge/Build-Interactive-brightgreen?style=for-the-badge)
![Dockerfile](https://img.shields.io/badge/Dockerfile-Arch%20Linux-blue?style=for-the-badge&logo=docker)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A highly configurable and modular Docker environment based on Arch Linux. Designed for security research, penetration testing, and general development, this project uses an interactive build script to create a tailored Linux environment with optional support for the BlackArch repository, the AUR, custom scripts, and `pipx` packages.

## Features

-   **Interactive Builder:** An easy-to-use `./build.sh` script guides you through the configuration process.
-   **Extensible with Scripts:** Place any executable script in the `scripts/` directory, and it will be available system-wide in the container's `PATH`.
-   **Secure:** Verifies the integrity of the BlackArch bootstrap script using a SHA-1 checksum.
-   **Modular:** Easily enable or disable large components like BlackArch, AUR, or `pipx` installations.
-   **Dotfiles Integration:** Automatically clones and runs the installation for your personal dotfiles repository.
-   **Reproducible:** Built on a pinned Arch Linux base image for consistent builds.
-   **Simple Package Management:** Just add package names to the text files in the `packages/` directory and rebuild.

## Project Structure

```
.
├── Dockerfile
├── README.md
├── build.sh            # Interactive build script (recommended)
└── packages/
│   ├── aur.txt
│   ├── blackarch.txt
│   ├── python.txt
│   └── system.txt
└── scripts/
    └── example.sh      # Custom scripts go here
```

## Prerequisites

-   [Docker](https://www.docker.com/get-started) installed and running.
-   A Unix-like shell (e.g., Bash, Zsh) to run the build script.

## Building the Image (Recommended)

The easiest way to build your custom image is with the interactive script.

1.  Make the script executable (only needs to be done once):
    ```bash
    chmod +x build.sh
    ```

2.  Run the script:
    ```bash
    ./build.sh
    ```

The script will guide you through building your custom container image.

## Customization

### 1. Adding Custom Scripts

Any executable file placed in the `scripts/` directory will be automatically copied to `/usr/local/bin` inside the container, making it available system-wide.

### 2. Managing Packages

To add or remove packages, simply edit the corresponding file in the `packages/` directory, then run `./build.sh` again.

-   `packages/system.txt`: For standard packages from the official Arch repositories.
-   `packages/blackarch.txt`: For tools from the BlackArch repository.
-   `packages/aur.txt`: For packages from the Arch User Repository.
-   `packages/python.txt`: For Python tools to be installed isolated via `pipx`.

## Running the Container

To start an interactive session, use the following command (replace `archpwnbox` with the image name you chose during the build):

```bash
docker run -it --rm archpwnbox
```

## Advanced Usage: Manual Builds

If you need to use this Dockerfile in an automated environment, you can call `docker build` directly with build arguments.

**Example:**
```bash
docker build \
    --build-arg USERNAME=hacker \
    --build-arg SKIP_BLACKARCH=false \
    -t my-pwnbox .
```

| Argument                   | Description                                                  | Default Value     |
| -------------------------- | ------------------------------------------------------------ | ----------------- |
| `USERNAME`                 | The name of the non-root user to create.                     | `user`            |
| `USER_SHELL`               | The default shell for the user.                              | `/bin/zsh`        |
| `DOTFILES_REPO`            | A Git URL to a dotfiles repository to clone and set up.      | `""` (empty)      |
| `CONTAINER_NAME`           | Name displayed in the welcome message.                       | `archpwnbox`      |
| `SKIP_BLACKARCH`           | Set to `false` to enable the BlackArch repo.                 | `true`            |
| `SKIP_AUR`                 | Set to `false` to enable AUR package installation.           | `true`            |
| `AUR_HELPER`               | The AUR helper to install (e.g., `yay-bin`, `paru-bin`).     | `yay-bin`         |
| `SKIP_PIPX`                | Set to `false` to enable `pipx` package installation.        | `true`            |
| `BLACKARCH_STRAP_SH_SHA1`  | The SHA-1 hash for the `strap.sh` script. **Must be updated if the script changes!** | (pre-filled hash) |

## License

This project is licensed under the MIT License.