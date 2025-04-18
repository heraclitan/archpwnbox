# archpwnbox - An Arch-based pentesting container
# Base image: Arch Linux
FROM archlinux:latest

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Initial system update
RUN pacman -Syu --noconfirm

# Setup BlackArch repository
RUN curl -O https://blackarch.org/strap.sh && \
    chmod +x strap.sh && \
    ./strap.sh && \
    rm strap.sh

# Copy package lists
COPY pacman-packages.txt /tmp/pacman-packages.txt

# Install packages from pacman-packages.txt
RUN if [ -s /tmp/pacman-packages.txt ]; then \
        pacman -S --noconfirm $(cat /tmp/pacman-packages.txt | grep -v "^#" | tr "\n" " "); \
    fi

# Copy entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create a non-root user for yay
RUN useradd -m -G wheel -s /bin/zsh archuser && \
    echo "archuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy yay packages list
COPY yay-packages.txt /tmp/yay-packages.txt

# Copy pipx packages list
COPY pipx-packages.txt /tmp/pipx-packages.txt

# Switch to the non-root user for AUR operations
USER archuser
WORKDIR /home/archuser

# Install yay
RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm --needed && \
    cd .. && \
    rm -rf yay-bin

# Install yay packages
RUN if [ -s /tmp/yay-packages.txt ]; then \
        yay -S --noconfirm $(cat /tmp/yay-packages.txt | grep -v "^#" | tr "\n" " "); \
    fi

# Configure pipx
RUN pipx ensurepath

# Install pipx packages
RUN if [ -s /tmp/pipx-packages.txt ]; then \
        cat /tmp/pipx-packages.txt | grep -v "^#" | while read package; do \
            if [ ! -z "$package" ]; then \
                pipx install "$package"; \
            fi \
        done \
    fi

# Setup for dotfiles
RUN mkdir -p /home/archuser/.config

# Clone archdawn repository and set up the dotfiles initialization script
RUN git clone https://github.com/heraclitan/archdawn.git /home/archuser/archdawn && \
    chmod +x /home/archuser/archdawn/archdawn && \
    ln -sf /home/archuser/archdawn/archdawn /home/archuser/init_dotfiles.sh

# Set environment variables
ENV TERM=xterm-256color
ENV PATH="/home/archuser/.local/bin:${PATH}"

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/zsh"]