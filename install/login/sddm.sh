#!/bin/bash
#
# ArcLabs OS Installer - SDDM Configuration
# Display manager setup with custom ArcLabs theme
#

login_sddm() {
    show_info "Configuring SDDM display manager..."

    # Enable SDDM service
    if ! systemctl is-enabled sddm.service &> /dev/null; then
        show_info "Enabling SDDM service..."
        if sudo systemctl enable sddm.service >> "$ARCLABS_LOG" 2>&1; then
            show_success "SDDM enabled"
            log_success "SDDM service enabled"
        else
            show_warning "Could not enable SDDM"
            log_warn "Failed to enable SDDM service"
        fi
    else
        show_info "SDDM already enabled"
        log_info "SDDM service already enabled"
    fi

    # Install ArcLabs SDDM theme
    local sddm_theme_src="$ARCLABS_PATH/themes/sddm/arclabs"
    local sddm_theme_dest="/usr/share/sddm/themes/arclabs"

    if [[ -d "$sddm_theme_src" ]]; then
        show_info "Installing ArcLabs SDDM theme..."
        sudo mkdir -p "$sddm_theme_dest"
        sudo cp -r "$sddm_theme_src"/* "$sddm_theme_dest/"
        show_success "ArcLabs SDDM theme installed"
        log_success "SDDM theme installed to $sddm_theme_dest"
    else
        log_warn "ArcLabs SDDM theme not found at $sddm_theme_src"
    fi

    # Create SDDM config directory
    local sddm_conf_dir="/etc/sddm.conf.d"
    sudo mkdir -p "$sddm_conf_dir"

    # Configure SDDM
    local sddm_conf="$sddm_conf_dir/10-arclabs.conf"

    show_info "Creating SDDM configuration..."
    sudo tee "$sddm_conf" > /dev/null << 'SDDMEOF'
[Theme]
Current=arclabs
CursorTheme=capitaine-cursors
CursorSize=24

[General]
InputMethod=
DefaultSession=hyprland-uwsm.desktop

[Users]
MaximumUid=60513
MinimumUid=1000
SDDMEOF
    show_success "SDDM configured"
    log_success "Created SDDM config: $sddm_conf"

    # Disable other display managers if present
    for dm in gdm lightdm lxdm; do
        if systemctl is-enabled "$dm.service" &> /dev/null 2>&1; then
            show_info "Disabling $dm..."
            sudo systemctl disable "$dm.service" >> "$ARCLABS_LOG" 2>&1 || true
            log_info "Disabled $dm"
        fi
    done

    # Remove duplicate Hyprland session if exists
    if [[ -f "/usr/share/wayland-sessions/hyprland.desktop" ]]; then
        sudo mv /usr/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop.bak 2>/dev/null || true
        log_info "Disabled duplicate Hyprland session"
    fi
}
