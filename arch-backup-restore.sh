#!/bin/bash

set -e

# Define directories and files
BACKUP_DIR="$HOME/arch-backup"
PKG_LIST="$BACKUP_DIR/pkglist.txt"
AUR_LIST="$BACKUP_DIR/aurpkglist.txt"
CONFIG_BACKUP="$BACKUP_DIR/arch-config-backup.tar.gz"

# Check if running as root (for certain operations)
if [[ "$EUID" -ne 0 ]]; then
   echo "Please run as root where required (e.g., package installation)."
fi

# Display usage
usage() {
    echo "Usage: $0 {backup|restore}"
    exit 1
}

# Backup function
backup() {
    echo "Starting backup..."

    # Create backup directory
    mkdir -p "$BACKUP_DIR"

    # Backup installed packages
    echo "Backing up package lists..."
    pacman -Qqe > "$PKG_LIST"
    pacman -Qqm > "$AUR_LIST"

    # Backup configurations (exclude cache files)
    echo "Backing up system configurations..."
    sudo tar czvf "$CONFIG_BACKUP" \
        --exclude="/home/*/.cache" \
        --exclude="/var/cache" \
        --exclude="/tmp" \
        --exclude="/home/*/.local" \
        --exclude="/home/*/Downloads" \
        --exclude="/home/*/.thunderbird" \
        --exclude="/home/*/arch-backup" \
        /etc /home /var/lib/pacman/local --warning=no-file-changed

    echo "Backup complete! Files saved in $BACKUP_DIR"
}

# Restore function
restore() {
    echo "Starting restoration..."

    # Ensure backup files exist
    if [[ ! -f "$PKG_LIST" || ! -f "$AUR_LIST" || ! -f "$CONFIG_BACKUP" ]]; then
        echo "Backup files not found! Ensure $BACKUP_DIR contains all required files."
        exit 1
    fi

    # Restore packages
    echo "Restoring official packages..."
    xargs -a "$PKG_LIST" sudo pacman -S --needed --noconfirm

    echo "Restoring AUR packages..."
    if ! command -v paru >/dev/null 2>&1; then
        echo "Please install an AUR helper (e.g., paru) before restoring AUR packages."
        exit 1
    fi
    xargs -a "$AUR_LIST" paru -S --needed --noconfirm

    # Restore configurations
    echo "Restoring system configurations..."
    tar xzvf "$CONFIG_BACKUP" -C / --warning=no-file-changed

    echo "Restoration complete!"
}

# Main script logic
if [[ $# -ne 1 ]]; then
    usage
fi

case "$1" in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    *)
        usage
        ;;
esac
