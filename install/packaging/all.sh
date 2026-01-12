#!/bin/bash
#
# ArcLabs OS Installer - Packaging Module
# All package installation
#

PACKAGING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$PACKAGING_DIR/base.sh"
source "$PACKAGING_DIR/aur.sh"
source "$PACKAGING_DIR/fonts.sh"
source "$PACKAGING_DIR/asahi.sh"

# Run all package installation
run_packaging() {
    set_phase "packaging"

    install_base_packages
    install_aur_packages
    install_fonts
    install_asahi_packages

    log_success "Packaging module completed"
}
