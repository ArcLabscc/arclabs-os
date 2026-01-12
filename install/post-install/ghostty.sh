#!/bin/bash
#
# ArcLabs OS Installer - Ghostty Build
# Builds Ghostty terminal from source (no ARM64 packages available)
#

post_ghostty() {
    log_step "Checking Ghostty terminal"

    # Check if ghostty is already installed
    if command -v ghostty &>/dev/null; then
        log_success "Ghostty already installed: $(ghostty --version | head -1)"
        return 0
    fi

    # Check for build script
    local BUILD_SCRIPT="$ARCLABS_PATH/../scripts/build-ghostty.sh"
    if [[ ! -f "$BUILD_SCRIPT" ]]; then
        BUILD_SCRIPT="$(dirname "$ARCLABS_INSTALL")/../scripts/build-ghostty.sh"
    fi

    if [[ -f "$BUILD_SCRIPT" ]]; then
        log_info "Building Ghostty from source (this may take 5-10 minutes)..."
        if bash "$BUILD_SCRIPT"; then
            log_success "Ghostty built successfully"
        else
            log_warn "Ghostty build failed - you can run scripts/build-ghostty.sh manually later"
        fi
    else
        log_warn "Ghostty build script not found"
        log_info "To install Ghostty later, run: scripts/build-ghostty.sh"
    fi
}
