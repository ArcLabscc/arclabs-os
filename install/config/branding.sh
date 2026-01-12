#!/bin/bash
#
# ArcLabs OS Installer - Branding Setup
# Configures screensaver text and branding assets
#

config_branding() {
    log_step "Setting up branding and screensaver"

    local BRANDING_DIR="$HOME/.config/arclabs-os/branding"
    local SOURCE_DIR="$ARCLABS_PATH/default/themed"

    # Create branding directory
    mkdir -p "$BRANDING_DIR"

    # Copy screensaver text
    if [[ -f "$SOURCE_DIR/screensaver.txt" ]]; then
        cp "$SOURCE_DIR/screensaver.txt" "$BRANDING_DIR/"
        log_success "Screensaver text installed"
    else
        # Create default if not exists
        cat > "$BRANDING_DIR/screensaver.txt" << 'EOF'

     █████╗ ██████╗  ██████╗██╗      █████╗ ██████╗ ███████╗     ██████╗ ███████╗
    ██╔══██╗██╔══██╗██╔════╝██║     ██╔══██╗██╔══██╗██╔════╝    ██╔═══██╗██╔════╝
    ███████║██████╔╝██║     ██║     ███████║██████╔╝███████╗    ██║   ██║███████╗
    ██╔══██║██╔══██╗██║     ██║     ██╔══██║██╔══██╗╚════██║    ██║   ██║╚════██║
    ██║  ██║██║  ██║╚██████╗███████╗██║  ██║██████╔╝███████║    ╚██████╔╝███████║
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝

EOF
        log_success "Default screensaver text created"
    fi

    log_success "Branding configured"
}
