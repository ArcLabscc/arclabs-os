#!/bin/bash
#
# ArcLabs OS Installer
# ARM64 Hyprland Desktop for Apple Silicon
#
# Usage: ./install.sh
#
# This installer sets up a complete Hyprland desktop environment
# optimized for Apple Silicon Macs running Asahi Linux.
#

set -eEo pipefail

# Export installation paths
export ARCLABS_PATH="$HOME/.local/share/arclabs-os"
export ARCLABS_INSTALL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install"
export ARCLABS_LOG="${ARCLABS_LOG:-/tmp/arclabs-install.log}"

# Check that install directory exists
if [[ ! -d "$ARCLABS_INSTALL" ]]; then
    echo "Error: install/ directory not found."
    echo "Please run this script from the arclabs-os repository root."
    exit 1
fi

# Source all modules
source "$ARCLABS_INSTALL/helpers/all.sh"
source "$ARCLABS_INSTALL/preflight/all.sh"
source "$ARCLABS_INSTALL/packaging/all.sh"
source "$ARCLABS_INSTALL/config/all.sh"
source "$ARCLABS_INSTALL/login/all.sh"
source "$ARCLABS_INSTALL/post-install/all.sh"

# Main installation flow
main() {
    # Phase 1: Preflight checks
    run_preflight

    # Phase 2: Package installation
    run_packaging

    # Phase 3: Configuration
    run_config

    # Phase 4: Login setup
    run_login

    # Phase 5: Finish
    run_post_install
}

# Run main with error handling
main "$@"
