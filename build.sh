#!/bin/bash

# --- Configuration ---
DEFAULT_IMAGE_NAME="archpwnbox"
DEFAULT_USERNAME="user"

# --- Helper Functions ---
ask_yes_no() {
    local question=$1
    local default=$2
    local answer

    if [ "$default" = "y" ]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    while true; do
        read -p "$question $prompt: " answer
        answer=${answer:-$default}
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            REPLY="true"
            return 0
        elif [[ "$answer" =~ ^[Nn]$ ]]; then
            REPLY="false"
            return 0
        fi
    done
}

# --- Main Script ---
echo "--- ArchPwnBox Interactive Builder ---"
echo

# Initialize build arguments array
BUILD_ARGS=()

# Ask questions and build the command
if ask_yes_no "Enable BlackArch repository and packages?" "n"; then
    BUILD_ARGS+=("--build-arg" "SKIP_BLACKARCH=false")
else
    BUILD_ARGS+=("--build-arg" "SKIP_BLACKARCH=true")
fi

if ask_yes_no "Enable AUR (yay) and packages?" "n"; then
    BUILD_ARGS+=("--build-arg" "SKIP_AUR=false")
else
    BUILD_ARGS+=("--build-arg" "SKIP_AUR=true")
fi

if ask_yes_no "Enable Python (pipx) and packages?" "n"; then
    BUILD_ARGS+=("--build-arg" "SKIP_PIPX=false")
else
    BUILD_ARGS+=("--build-arg" "SKIP_PIPX=true")
fi

echo
read -p "Enter the username for the container [$DEFAULT_USERNAME]: " username
username=${username:-$DEFAULT_USERNAME}
BUILD_ARGS+=("--build-arg" "USERNAME=$username")

read -p "Enter the Git URL for your dotfiles (or press Enter to skip): " dotfiles_repo
if [ -n "$dotfiles_repo" ]; then
    BUILD_ARGS+=("--build-arg" "DOTFILES_REPO=$dotfiles_repo")
fi

echo
read -p "Enter the name (tag) for the final Docker image [$DEFAULT_IMAGE_NAME]: " image_name
image_name=${image_name:-$DEFAULT_IMAGE_NAME}

# Construct the final command
FULL_COMMAND="docker build ${BUILD_ARGS[@]} -t \"$image_name\" ."

# Display and execute the command
echo
echo "The following command will be executed:"
echo "--------------------------------------------------"
echo "$FULL_COMMAND"
echo "--------------------------------------------------"
echo

if ask_yes_no "Proceed with the build?" "y"; then
    eval "$FULL_COMMAND"
else
    echo "Build cancelled."
    exit 1
fi