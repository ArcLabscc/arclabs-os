#!/bin/bash
#
# ArcLabs OS Installer - Install Files
# Copy bin/, default/, themes/ to installation directory
#

config_install_files() {
    show_section "Installing ArcLabs OS Files"

    local install_dir="$ARCLABS_PATH"
    local source_dir="$ARCLABS_INSTALL/.."

    show_info "Installing to $install_dir..."
    log_info "Installing ArcLabs OS files to $install_dir"

    # Create installation directory
    mkdir -p "$install_dir"

    # Copy bin/ scripts
    if [[ -d "$source_dir/bin" ]]; then
        show_info "Copying scripts..."
        cp -r "$source_dir/bin" "$install_dir/"
        chmod +x "$install_dir/bin/"* 2>/dev/null || true
        local bin_count=$(ls -1 "$install_dir/bin" 2>/dev/null | wc -l)
        show_success "Installed $bin_count scripts"
        log_success "Installed $bin_count bin scripts"
    else
        show_warning "bin/ directory not found"
        log_warn "Source bin/ directory missing"
    fi

    # Copy default/ files
    if [[ -d "$source_dir/default" ]]; then
        show_info "Copying defaults..."
        cp -r "$source_dir/default" "$install_dir/"
        show_success "Default files installed"
        log_success "Default files installed"
    else
        log_info "No default/ directory to copy"
    fi

    # Copy themes/
    if [[ -d "$source_dir/themes" ]]; then
        show_info "Copying themes..."
        cp -r "$source_dir/themes" "$install_dir/"
        local theme_count=$(ls -1 "$install_dir/themes" 2>/dev/null | wc -l)
        show_success "Installed $theme_count base themes"
        log_success "Installed $theme_count themes"
    else
        show_warning "themes/ directory not found"
        log_warn "Source themes/ directory missing"
    fi

    # Copy omarchy-themes/ (additional themes)
    if [[ -d "$source_dir/omarchy-themes" ]]; then
        show_info "Copying additional themes..."
        cp -r "$source_dir/omarchy-themes/"* "$install_dir/themes/" 2>/dev/null || true
        local total_themes=$(ls -1 "$install_dir/themes" 2>/dev/null | wc -l)
        show_success "Total themes: $total_themes"
        log_success "Copied omarchy-themes to themes/"
    fi

    # Copy elephant menus config
    if [[ -d "$source_dir/config/elephant" ]]; then
        show_info "Copying Walker menus..."
        mkdir -p "$HOME/.config/elephant"
        cp -r "$source_dir/config/elephant/"* "$HOME/.config/elephant/"
        show_success "Walker menus installed"
        log_success "Elephant menus config installed"
    fi

    # Copy applications/ (desktop entries)
    if [[ -d "$source_dir/applications" ]]; then
        show_info "Copying application entries..."
        cp -r "$source_dir/applications" "$install_dir/"
        show_success "Application entries installed"
        log_success "Application entries installed"
    fi

    show_success "ArcLabs OS files installed to $install_dir"
    log_success "File installation completed"
}
