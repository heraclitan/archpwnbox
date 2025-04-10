# archpwnbox - An Arch-based pentesting container
# Base image: Arch Linux
FROM archlinux:latest

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Install basic tools
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git wget curl sudo

# Setup BlackArch repository
RUN curl -O https://blackarch.org/strap.sh && \
    chmod +x strap.sh && \
    ./strap.sh && \
    rm strap.sh

# Copy package lists
COPY pacman-packages.txt /tmp/pacman-packages.txt
COPY yay-packages.txt /tmp/yay-packages.txt

# Install packages from pacman-packages.txt
RUN if [ -s /tmp/pacman-packages.txt ]; then \
        pacman -S --noconfirm $(cat /tmp/pacman-packages.txt | grep -v "^#" | tr "\n" " "); \
    fi

# Create a non-root user for yay
RUN useradd -m -G wheel -s /bin/bash archuser && \
    echo "archuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the non-root user
USER archuser
WORKDIR /home/archuser

# Install yay
RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm --needed && \
    cd .. && \
    rm -rf yay-bin

# Install seclists using yay
RUN if [ -s /tmp/yay-packages.txt ]; then \
        yay -S --noconfirm $(cat /tmp/yay-packages.txt | grep -v "^#" | tr "\n" " "); \
    fi

# Setup for dotfiles
RUN mkdir -p /home/archuser/.config

# Clone archdawn repository and set up the dotfiles initialization script
RUN git clone https://github.com/heraclitan/archdawn.git /home/archuser/archdawn && \
    chmod +x /home/archuser/archdawn/archdawn && \
    ln -sf /home/archuser/archdawn/archdawn /home/archuser/init_dotfiles.sh

# Set up entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define TERM environment variable
ENV TERM=xterm-256color

# Set the default user to archuser
USER archuser
WORKDIR /home/archuser

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]