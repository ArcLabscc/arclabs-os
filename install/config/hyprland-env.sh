#!/bin/bash
#
# ArcLabs OS Installer - Hyprland Environment
# Configure Hyprland environment variables
#

config_hyprland_env() {
    show_section "Configuring Hyprland Environment"

    local hypr_dir="$HOME/.config/hypr"
    local envs_file="$hypr_dir/envs.conf"

    mkdir -p "$hypr_dir"

    # Check if envs.conf exists and needs PATH
    if [[ -f "$envs_file" ]]; then
        if ! grep -q "arclabs-os/bin" "$envs_file"; then
            show_info "Adding ArcLabs OS to Hyprland environment..."
            echo '' >> "$envs_file"
            echo '# ArcLabs OS' >> "$envs_file"
            echo 'env = PATH,$HOME/.local/share/arclabs-os/bin:$PATH' >> "$envs_file"
            echo 'env = ARCLABS_PATH,$HOME/.local/share/arclabs-os' >> "$envs_file"
            show_success "Updated envs.conf"
            log_success "Added PATH to Hyprland envs.conf"
        else
            show_info "Hyprland environment already configured"
            log_info "envs.conf already has arclabs-os PATH"
        fi
    else
        show_info "Creating Hyprland environment config..."
        cat > "$envs_file" << 'ENVEOF'
# ArcLabs OS Environment Variables
# Sourced by hyprland.conf

# ArcLabs OS PATH
env = PATH,$HOME/.local/share/arclabs-os/bin:$PATH
env = ARCLABS_PATH,$HOME/.local/share/arclabs-os

# Wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Qt
env = QT_QPA_PLATFORM,wayland
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_AUTO_SCREEN_SCALE_FACTOR,1

# GTK
env = GDK_BACKEND,wayland,x11

# Cursor
env = XCURSOR_SIZE,24
env = XCURSOR_THEME,capitaine-cursors
ENVEOF
        show_success "Created envs.conf"
        log_success "Created Hyprland envs.conf"
    fi

    show_success "Hyprland environment configured"
}
