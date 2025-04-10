#!/bin/bash
# Package management script for ArchPwnBox
# Helps add packages to the appropriate list files

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'
BOLD='\033[1m'

PACMAN_LIST="pacman-packages.txt"
YAY_LIST="yay-packages.txt"

show_help() {
    echo -e "${BOLD}ArchPwnBox Package Manager${RESET}"
    echo
    echo "Usage: $0 [OPTION] [PACKAGE...]"
    echo
    echo "Options:"
    echo "  -p, --pacman    Add packages to pacman list"
    echo "  -y, --yay       Add packages to yay/AUR list"
    echo "  -r, --remove    Remove packages from both lists"
    echo "  -l, --list      List current packages"
    echo "  -h, --help      Show this help message"
    echo
    echo "Examples:"
    echo "  $0 -p nmap wireshark    # Add nmap and wireshark to pacman list"
    echo "  $0 -y seclists          # Add seclists to yay list"
    echo "  $0 -r nmap              # Remove nmap from any list"
    echo "  $0 -l                   # List current packages"
}

list_packages() {
    echo -e "${BOLD}${BLUE}Current packages:${RESET}"
    echo
    echo -e "${BOLD}Pacman packages:${RESET}"
    if [ -f "$PACMAN_LIST" ]; then
        grep -v "^#" "$PACMAN_LIST" | grep -v "^$" | sort
    else
        echo "No pacman package list found."
    fi

    echo
    echo -e "${BOLD}Yay/AUR packages:${RESET}"
    if [ -f "$YAY_LIST" ]; then
        grep -v "^#" "$YAY_LIST" | grep -v "^$" | sort
    else
        echo "No yay package list found."
    fi
}

add_packages() {
    local list_file=$1
    shift
    local packages=("$@")

    # Check if list file exists
    if [ ! -f "$list_file" ]; then
        echo -e "${RED}Error: List file $list_file not found.${RESET}"
        exit 1
    fi

    # Add packages to list
    for pkg in "${packages[@]}"; do
        if grep -q "^$pkg$" "$list_file"; then
            echo -e "${BLUE}Package $pkg already in list.${RESET}"
        else
            echo "$pkg" >> "$list_file"
            echo -e "${GREEN}Added $pkg to $list_file.${RESET}"
        fi
    done
}

# Check if no arguments
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

remove_packages() {
    local packages=("$@")
    local removed=false

    for pkg in "${packages[@]}"; do
        # Try to remove from pacman list
        if [ -f "$PACMAN_LIST" ] && grep -q "^$pkg$" "$PACMAN_LIST"; then
            sed -i "/^$pkg$/d" "$PACMAN_LIST"
            echo -e "${GREEN}Removed $pkg from $PACMAN_LIST.${RESET}"
            removed=true
        fi

        # Try to remove from yay list
        if [ -f "$YAY_LIST" ] && grep -q "^$pkg$" "$YAY_LIST"; then
            sed -i "/^$pkg$/d" "$YAY_LIST"
            echo -e "${GREEN}Removed $pkg from $YAY_LIST.${RESET}"
            removed=true
        fi

        if [ "$removed" = false ]; then
            echo -e "${RED}Package $pkg not found in any list.${RESET}"
        fi
    done
}

# Parse options
case "$1" in
    -p|--pacman)
        shift
        if [ $# -eq 0 ]; then
            echo -e "${RED}Error: No packages specified.${RESET}"
            exit 1
        fi
        add_packages "$PACMAN_LIST" "$@"
        ;;
    -y|--yay)
        shift
        if [ $# -eq 0 ]; then
            echo -e "${RED}Error: No packages specified.${RESET}"
            exit 1
        fi
        add_packages "$YAY_LIST" "$@"
        ;;
    -r|--remove)
        shift
        if [ $# -eq 0 ]; then
            echo -e "${RED}Error: No packages specified.${RESET}"
            exit 1
        fi
        remove_packages "$@"
        ;;
    -l|--list)
        list_packages
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo -e "${RED}Error: Unknown option $1${RESET}"
        show_help
        exit 1
        ;;
esac

exit 0
