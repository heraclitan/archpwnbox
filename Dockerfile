# Use a real, existing base image tag for reproducibility.
FROM archlinux:base-20250622.0.370030

# Build arguments for customization, defined once at the top.
ARG USERNAME=user
ARG USER_SHELL=/bin/zsh
ARG DOTFILES_REPO=""
ARG CONTAINER_NAME="archpwnbox"
ARG SKIP_BLACKARCH=false
ARG SKIP_AUR=false
ARG AUR_HELPER=yay-bin
ARG SKIP_PIPX=false
ARG BLACKARCH_STRAP_SH_SHA1="bbf0a0b838aed0ec05fff2d375dd17591cbdf8aa"

# === STAGE 1: SYSTEM SETUP AS ROOT ===
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm zsh bash git base-devel curl sudo && \
    if [ "$SKIP_PIPX" != "true" ]; then pacman -S --noconfirm python-pipx; fi && \
    pacman -Scc --noconfirm

# Optional: Install BlackArch repository with checksum verification
RUN if [ "$SKIP_BLACKARCH" != "true" ]; then \
        curl -fsSL https://blackarch.org/strap.sh -o strap.sh && \
        echo "$BLACKARCH_STRAP_SH_SHA1 strap.sh" | sha1sum -c - && \
        chmod +x strap.sh && ./strap.sh && rm strap.sh && \
        pacman -Scc --noconfirm; \
    fi

RUN useradd -mG wheel -s "$USER_SHELL" "$USERNAME" && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/10-$USERNAME" && \
    echo "Defaults lecture = never" >> "/etc/sudoers.d/10-$USERNAME"

COPY --chmod=755 scripts/ /usr/local/bin/
COPY packages/system.txt packages/blackarch.txt /tmp/

RUN ( \
        if [ -s /tmp/system.txt ]; then cat /tmp/system.txt; fi; \
        if [ "$SKIP_BLACKARCH" != "true" ] && [ -s /tmp/blackarch.txt ]; then \
            echo "--> Including packages from blackarch.txt" >&2; \
            cat /tmp/blackarch.txt; \
        fi \
    ) | grep -v '^#' | grep -v '^[[:space:]]*$' | xargs -r pacman -S --noconfirm && \
    pacman -Scc --noconfirm && \
    rm -f /tmp/system.txt /tmp/blackarch.txt

# === STAGE 2: USER-SPECIFIC SETUP ===
USER $USERNAME
WORKDIR /home/$USERNAME
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

COPY packages/aur.txt packages/python.txt /tmp/

RUN if [ "$SKIP_AUR" != "true" ] && [ -s /tmp/aur.txt ]; then \
        git clone "https://aur.archlinux.org/$AUR_HELPER.git" && \
        cd "$AUR_HELPER" && makepkg -si --noconfirm --needed && cd .. && rm -rf "$AUR_HELPER" && \
        grep -v '^#' /tmp/aur.txt | xargs -r yay -S --noconfirm --removemake --cleanafter && \
        yay -Scc --noconfirm && \
        rm -f /tmp/aur.txt; \
    fi

RUN if [ "$SKIP_PIPX" != "true" ] && [ -s /tmp/python.txt ]; then \
        grep -v '^#' /tmp/python.txt | xargs -r --no-run-if-empty -n 1 pipx install && \
        rm -f /tmp/python.txt; \
    fi

RUN if [ -n "$DOTFILES_REPO" ]; then \
        git clone --depth=1 "$DOTFILES_REPO" dotfiles && cd dotfiles && \
        if [ -f install.sh ]; then chmod +x install.sh && ./install.sh; \
        elif [ -f setup.sh ]; then chmod +x setup.sh && ./setup.sh; \
        elif [ -d .config ]; then cp -r .config ~/ && echo "Copied .config directory."; \
        else echo "Warning: No known dotfiles installation method found."; fi && \
        cd .. && rm -rf dotfiles; \
    fi

RUN shell_name=$(basename "$USER_SHELL") && \
    config_file="/home/$USERNAME/.$shell_name"rc && \
    { \
        echo ""; \
        echo "# Appended by Dockerfile: Display welcome message for interactive shells"; \
        echo 'if [[ $- == *i* ]]; then'; \
        echo "  cat <<'EOF'"; \
        echo "==========================================================="; \
        echo " Welcome to \$CONTAINER_NAME!"; \
        echo " Logged in as user: $USERNAME"; \
        echo "==========================================================="; \
        echo "EOF"; \
        echo "fi"; \
    } >> "$config_file"

# === FINAL IMAGE CONFIGURATION ===
ENV CONTAINER_NAME=$CONTAINER_NAME

## CORRECTED CMD ##
# Use the reliable "exec form". This starts the shell specified by the
# ARG by default, ensuring the container stays running for interactive use.
CMD ["/bin/zsh"]