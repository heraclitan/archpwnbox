# archpwnbox - An Arch-based pentesting container
# Base image: Arch Linux
FROM archlinux:latest

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Update system and install basic tools
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git wget curl sudo vim neovim

# Setup BlackArch repository
RUN curl -O https://blackarch.org/strap.sh && \
    chmod +x strap.sh && \
    ./strap.sh && \
    rm strap.sh

# Install nmap using pacman
RUN pacman -S --noconfirm nmap

# Create a non-root user for yay
RUN useradd -m -G wheel -s /bin/bash archuser && \
    echo "archuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the non-root user
USER archuser
WORKDIR /home/archuser

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay

# Install seclists using yay
RUN yay -S --noconfirm seclists

# Setup for dotfiles
RUN mkdir -p /home/archuser/.config

# Clone archdawn repository and set up the dotfiles initialization script
RUN git clone https://github.com/heraclitan/archdawn.git /home/archuser/archdawn && \
    chmod +x /home/archuser/archdawn/archdawn && \
    ln -sf /home/archuser/archdawn/archdawn /home/archuser/init_dotfiles.sh

# Switch back to root for final setup
USER root

# Set up entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]
