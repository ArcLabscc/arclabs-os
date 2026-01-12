#!/bin/bash
#
# ArcLabs OS Installer - Plymouth Theme Setup
# Installs and configures ArcLabs boot splash
#

config_plymouth() {
    log_step "Configuring Plymouth boot splash"

    local PLYMOUTH_DIR="/usr/share/plymouth/themes/arclabs"
    local SOURCE_DIR="$ARCLABS_PATH/themes/plymouth/arclabs"

    # Check if plymouth theme files exist
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_warn "Plymouth theme files not found, skipping"
        return 0
    fi

    # Install plymouth theme
    run_cmd "sudo mkdir -p $PLYMOUTH_DIR"
    run_cmd "sudo cp -r $SOURCE_DIR/* $PLYMOUTH_DIR/"

    # Set as default theme
    run_cmd "sudo plymouth-set-default-theme -R arclabs" || {
        log_warn "Failed to set Plymouth theme, trying manual setup"
        # Manual fallback
        if [[ -f /etc/plymouth/plymouthd.conf ]]; then
            sudo sed -i 's/Theme=.*/Theme=arclabs/' /etc/plymouth/plymouthd.conf 2>/dev/null || true
        fi
    }

    # Rebuild initramfs to include theme
    run_cmd "sudo mkinitcpio -P" || log_warn "Failed to rebuild initramfs"

    log_success "Plymouth theme configured"
}
