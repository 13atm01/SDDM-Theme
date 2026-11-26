#!/usr/bin/env bash
# ============================================================
# Wuthering Waves | Mornye SDDM Theme Uninstaller
# Author: 13atm01 alias Andi Trisna Mukti
# License: GPL-3.0
# ============================================================

set -e

# Output colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

THEME_NAME="Mornye"
THEME_DIR="/usr/share/sddm/themes"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_CONF_FILE="$SDDM_CONF_DIR/Mornye.conf"

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║      Wuthering Waves | Mornye SDDM Uninstaller       ║"
    echo "║                          by                          ║"
    echo "║                  Andi Trisna Mukti                   ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run with sudo/root${RESET}"
        echo "Usage: sudo ./uninstall.sh"
        exit 1
    fi
}

remove_theme() {
    echo -e "\n${CYAN}🗑️  Removing theme files...${RESET}"

    # Remove theme directory
    if [[ -d "$THEME_DIR/$THEME_NAME" ]]; then
        sudo rm -rf "$THEME_DIR/$THEME_NAME"
        echo -e "${GREEN}✓ Theme removed from $THEME_DIR/$THEME_NAME${RESET}"
    else
        echo -e "${YELLOW}⚠ Theme directory not found at $THEME_DIR/$THEME_NAME${RESET}"
    fi
}

remove_config() {
    echo -e "\n${CYAN}⚙️  Reverting SDDM configuration...${RESET}"

    # 1. Remove drop-in configuration file
    if [[ -f "$SDDM_CONF_FILE" ]]; then
        sudo rm -f "$SDDM_CONF_FILE"
        echo -e "${GREEN}✓ Removed $SDDM_CONF_FILE${RESET}"
    else
        echo -e "${YELLOW}⚠ Drop-in config not found${RESET}"
    fi

    # 2. Restore /etc/sddm.conf from backup (if created by install.sh)
    # Find the most recent backup file
    LATEST_BACKUP=$(ls -t /etc/sddm.conf.backup.* 2>/dev/null | head -n 1)

    if [[ -n "$LATEST_BACKUP" ]]; then
        echo -e "${YELLOW}Restoring /etc/sddm.conf from backup...${RESET}"
        sudo cp "$LATEST_BACKUP" /etc/sddm.conf
        echo -e "${GREEN}✓ /etc/sddm.conf restored from $LATEST_BACKUP${RESET}"

        # Optional: remove the backup file to keep system clean
        # sudo rm -f "$LATEST_BACKUP"
    else
        # Fallback: If no backup exists, manually remove the Mornye reference
        echo -e "${YELLOW}No backup found. Manually removing Mornye from /etc/sddm.conf...${RESET}"
        if [[ -f /etc/sddm.conf ]]; then
            # Remove the 'Current=Mornye' line
            sudo sed -i '/^Current=Mornye$/d' /etc/sddm.conf
            echo -e "${GREEN}✓ Removed 'Current=Mornye' from /etc/sddm.conf${RESET}"
        fi
    fi
}

print_success() {
    echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║        Wuthering Waves | Mornye SDDM Theme         ║${RESET}"
    echo -e "${GREEN}║           ✅ Successfully Uninstalled ✅           ║${RESET}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${RESET}"

    echo -e "\n${CYAN}⚠️  Important: SDDM will revert to its default theme.${RESET}"
    echo -e "Please restart SDDM to apply changes:"
    echo -e "${YELLOW}sudo systemctl restart sddm${RESET}\n"
}

# ===== MAIN =====
print_header
check_root
remove_theme
remove_config
print_success
