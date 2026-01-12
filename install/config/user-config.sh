#!/bin/bash
#
# ArcLabs OS Installer - User Configuration
# Copy configs to ~/.config/
#

config_user_config() {
    show_section "Installing User Configuration"

    local config_dir="$HOME/.config"
    local source_dir="$ARCLABS_INSTALL/../config"

    # Create config directories
    mkdir -p "$config_dir"
    mkdir -p "$config_dir/arclabs-os/current"

    if [[ -d "$source_dir" ]]; then
        show_info "Copying configuration files..."
        log_info "Copying config/ to $config_dir"

        # Copy all config subdirectories
        for item in "$source_dir"/*; do
            if [[ -d "$item" ]]; then
                local name=$(basename "$item")
                show_info "  → $name/"

                # Create target directory
                mkdir -p "$config_dir/$name"

                # Copy contents (merge with existing)
                cp -r "$item"/* "$config_dir/$name/" 2>/dev/null || \
                cp -r "$item"/* "$config_dir/$name" 2>/dev/null || true

                log_info "Copied config: $name"
            elif [[ -f "$item" ]]; then
                local name=$(basename "$item")
                cp "$item" "$config_dir/" 2>/dev/null || true
                log_info "Copied config file: $name"
            fi
        done

        show_success "Configuration files installed"
        log_success "User configuration installed"
    else
        show_warning "No config/ directory found"
        log_warn "Source config/ directory missing"
    fi

    # Ensure ArcLabs OS state directory exists
    mkdir -p "$config_dir/arclabs-os/current"
    log_info "Created arclabs-os state directory"
}
