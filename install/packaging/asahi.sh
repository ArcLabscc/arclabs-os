#!/bin/bash
#
# ArcLabs OS Installer - Asahi Linux Specific Packages
# Apple Silicon hardware support
#

install_asahi_packages() {
    show_section "Asahi Linux Packages"

    if [[ "$ARCLABS_IS_ASAHI" != "1" ]]; then
        show_info "Not running on Asahi Linux - skipping Asahi-specific packages"
        log_info "Skipping Asahi packages (not on Asahi Linux)"
        return 0
    fi

    show_info "Installing Apple Silicon support packages..."
    log_info "Installing Asahi Linux packages"

    # Core Asahi packages
    local asahi_packages=(
        "asahi-meta"
        "asahi-scripts"
        "asahi-fwextract"
        "linux-asahi"
        "m1n1"
        "uboot-asahi"
    )

    for pkg in "${asahi_packages[@]}"; do
        if pacman -Qi "$pkg" &> /dev/null; then
            show_info "$pkg already installed"
            log_info "$pkg already present"
        else
            show_info "Installing $pkg..."
            if sudo pacman -S --needed --noconfirm "$pkg" >> "$ARCLABS_LOG" 2>&1; then
                show_success "$pkg installed"
                log_success "Installed: $pkg"
            else
                show_warning "Could not install $pkg"
                log_warn "Failed to install: $pkg"
            fi
        fi
    done

    # Check for Asahi keyring
    if ! pacman -Qi asahi-alarm-keyring &> /dev/null; then
        show_info "Installing Asahi keyring..."
        if sudo pacman -S --needed --noconfirm asahi-alarm-keyring >> "$ARCLABS_LOG" 2>&1; then
            show_success "Asahi keyring installed"
            log_success "Asahi keyring installed"
        fi
    fi

    show_success "Asahi Linux packages configured"
    log_success "Asahi packages completed"
}
