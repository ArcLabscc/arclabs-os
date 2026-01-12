#!/bin/bash
#
# ArcLabs OS Installer - UWSM Configuration
# Universal Wayland Session Manager setup
#

login_uwsm() {
    show_info "Configuring UWSM session manager..."

    # Check if uwsm is installed
    if ! command -v uwsm &> /dev/null; then
        show_warning "UWSM not installed"
        log_warn "uwsm command not found"
        return 0
    fi

    # Check for Hyprland UWSM desktop entry
    local uwsm_desktop="/usr/share/wayland-sessions/hyprland-uwsm.desktop"
    local alt_desktop="/usr/share/xsessions/hyprland-uwsm.desktop"

    if [[ -f "$uwsm_desktop" ]] || [[ -f "$alt_desktop" ]]; then
        show_success "UWSM Hyprland session available"
        log_info "hyprland-uwsm.desktop found"
    else
        show_info "Creating UWSM session entry..."

        # Create the desktop entry
        sudo mkdir -p /usr/share/wayland-sessions
        sudo tee /usr/share/wayland-sessions/hyprland-uwsm.desktop > /dev/null << 'UWSMEOF'
[Desktop Entry]
Name=Hyprland (uwsm-managed)
Comment=Hyprland compositor with UWSM session management
Exec=uwsm start hyprland
Type=Application
DesktopNames=Hyprland
Keywords=wayland;compositor;tiling;
UWSMEOF
        show_success "UWSM session entry created"
        log_success "Created hyprland-uwsm.desktop"
    fi

    # UWSM environment configuration
    local uwsm_env="$HOME/.config/uwsm/env"
    mkdir -p "$(dirname "$uwsm_env")"

    if [[ ! -f "$uwsm_env" ]]; then
        show_info "Creating UWSM environment..."
        cat > "$uwsm_env" << 'UWSMENVEOF'
# UWSM Environment for ArcLabs OS
# These are set before Hyprland starts

# ArcLabs OS PATH
PATH="$HOME/.local/share/arclabs-os/bin:$PATH"
ARCLABS_PATH="$HOME/.local/share/arclabs-os"

# XDG
XDG_CURRENT_DESKTOP=Hyprland
XDG_SESSION_TYPE=wayland
XDG_SESSION_DESKTOP=Hyprland

# Qt
QT_QPA_PLATFORM=wayland
QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# GTK
GDK_BACKEND=wayland,x11
UWSMENVEOF
        show_success "UWSM environment configured"
        log_success "Created UWSM env file"
    else
        log_info "UWSM env already exists"
    fi

    show_success "UWSM session manager ready"
}
