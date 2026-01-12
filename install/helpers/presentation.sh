#!/bin/bash
#
# ArcLabs OS Installer - Presentation Helpers
# Colors, banners, and progress display
#

# Colors
export GREEN="\033[0;32m"
export CYAN="\033[0;36m"
export YELLOW="\033[1;33m"
export RED="\033[0;31m"
export BOLD="\033[1m"
export DIM="\033[2m"
export NC="\033[0m"

# ASCII Banner
show_banner() {
    echo -e "${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║                                                   ║
    ║     █████╗ ██████╗  ██████╗██╗      █████╗ ██████╗║
    ║    ██╔══██╗██╔══██╗██╔════╝██║     ██╔══██╗██╔══██║
    ║    ███████║██████╔╝██║     ██║     ███████║██████╔║
    ║    ██╔══██║██╔══██╗██║     ██║     ██╔══██║██╔══██║
    ║    ██║  ██║██║  ██║╚██████╗███████╗██║  ██║██████╔║
    ║    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═════╝║
    ║                                                   ║
    ║         ARM64 Hyprland for Apple Silicon          ║
    ║                                                   ║
    ╚═══════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Progress step display
# Usage: show_step 1 8 "Installing packages"
show_step() {
    local current=$1
    local total=$2
    local message=$3
    echo -e "${CYAN}[${current}/${total}]${NC} ${message}..."
}

# Success message
show_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Warning message
show_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Error message
show_error() {
    echo -e "${RED}✗${NC} $1"
}

# Info message
show_info() {
    echo -e "${DIM}→${NC} $1"
}

# Section header
show_section() {
    echo ""
    echo -e "${BOLD}$1${NC}"
    echo -e "${DIM}$(printf '─%.0s' {1..50})${NC}"
}

# Completion banner
show_complete() {
    echo -e "${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║                                                   ║
    ║       Installation Complete!                      ║
    ║                                                   ║
    ╚═══════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}
