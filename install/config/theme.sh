#!/bin/bash
#
# ArcLabs OS Installer - Theme Setup
# Configure default theme and background
#

config_theme() {
    show_section "Configuring Theme"

    local config_dir="$HOME/.config/arclabs-os/current"
    local themes_dir="$ARCLABS_PATH/themes"
    local default_theme="arclabs"

    mkdir -p "$config_dir"

    # Set up theme symlink
    if [[ -d "$themes_dir/$default_theme" ]]; then
        show_info "Setting default theme: $default_theme"

        # Create theme symlink
        ln -sfn "$themes_dir/$default_theme" "$config_dir/theme"
        show_success "Theme linked: $default_theme"
        log_success "Theme symlink created: $default_theme"
    else
        show_warning "Default theme not found: $default_theme"
        log_warn "Theme directory missing: $themes_dir/$default_theme"

        # Try first available theme
        local first_theme=$(ls -1 "$themes_dir" 2>/dev/null | head -1)
        if [[ -n "$first_theme" ]] && [[ -d "$themes_dir/$first_theme" ]]; then
            ln -sfn "$themes_dir/$first_theme" "$config_dir/theme"
            show_info "Using fallback theme: $first_theme"
            log_info "Fallback theme: $first_theme"
        fi
    fi

    # Set up default background
    if [[ ! -L "$config_dir/background" ]] && [[ ! -f "$config_dir/background" ]]; then
        local bg_dir="$themes_dir/$default_theme/backgrounds"

        if [[ -d "$bg_dir" ]] && [[ "$(ls -A $bg_dir 2>/dev/null)" ]]; then
            local first_bg=$(ls -1 "$bg_dir" | head -1)
            ln -sfn "$bg_dir/$first_bg" "$config_dir/background"
            show_success "Default background set: $first_bg"
            log_success "Background symlink: $first_bg"
        else
            log_info "No backgrounds found in theme"
        fi
    else
        show_info "Background already configured"
        log_info "Background symlink already exists"
    fi

    # Configure GTK/GNOME settings for dark mode
    show_info "Setting dark mode preferences..."

    # Set color scheme to prefer dark
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

    # Set GTK theme to dark variant
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

    # Set cursor theme
    gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors' 2>/dev/null || true

    # Set icon theme
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita' 2>/dev/null || true

    show_success "Dark mode configured"
    log_success "GTK/GNOME dark mode preferences set"

    show_success "Theme configuration complete"
}
