#!/bin/bash
#
# ArcLabs OS Installer - Base Package Installation
# Install packages from official Arch Linux ARM repos
#

install_base_packages() {
    show_section "Installing Base Packages"

    local package_file="$ARCLABS_INSTALL/arclabs-base.packages"

    if [[ ! -f "$package_file" ]]; then
        log_error "Package file not found: $package_file"
        show_error "Package list missing!"
        return 1
    fi

    # Count packages (excluding comments and blank lines)
    local total=$(grep -v '^#' "$package_file" | grep -v '^$' | wc -l)
    show_info "Installing $total packages from official repos..."
    log_info "Installing $total base packages"

    # Install packages
    if grep -v '^#' "$package_file" | grep -v '^$' | \
       sudo pacman -S --needed --noconfirm - >> "$ARCLABS_LOG" 2>&1; then
        show_success "Base packages installed"
        log_success "Base packages installed successfully"
    else
        # Pacman returns non-zero even if some packages are unavailable
        # Check if critical packages are present
        local failed=0
        for pkg in hyprland waybar kitty; do
            if ! pacman -Qi "$pkg" &> /dev/null; then
                log_error "Critical package missing: $pkg"
                failed=1
            fi
        done

        if [[ $failed -eq 1 ]]; then
            show_error "Some critical packages failed to install"
            return 1
        else
            show_warning "Some optional packages may be missing (check log)"
            log_warn "Pacman had warnings but critical packages are present"
        fi
    fi
}
