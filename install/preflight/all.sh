#!/bin/bash
#
# ArcLabs OS Installer - Preflight Module
# All pre-installation checks and setup
#

PREFLIGHT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$PREFLIGHT_DIR/guard.sh"
source "$PREFLIGHT_DIR/show-env.sh"
source "$PREFLIGHT_DIR/pacman.sh"

# Run all preflight checks
run_preflight() {
    set_phase "preflight"

    show_banner

    preflight_guard || exit 1
    preflight_show_env
    preflight_pacman

    log_success "Preflight module completed"
}
