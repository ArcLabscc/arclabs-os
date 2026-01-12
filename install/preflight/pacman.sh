#!/bin/bash
#
# ArcLabs OS Installer - Pacman Preparation
# Update package database and ensure base-devel
#

preflight_pacman() {
    show_section "Package Manager Setup"

    # Update package database
    show_info "Updating package database..."
    log_info "Running pacman -Sy"

    if sudo pacman -Sy --noconfirm >> "$ARCLABS_LOG" 2>&1; then
        show_success "Package database updated"
        log_success "Pacman database updated"
    else
        show_warning "Package database update had issues (continuing anyway)"
        log_warn "Pacman -Sy returned non-zero"
    fi

    # Ensure base-devel is installed (needed for AUR)
    if ! pacman -Qi base-devel &> /dev/null; then
        show_info "Installing base-devel..."
        log_info "Installing base-devel"

        if sudo pacman -S --needed --noconfirm base-devel >> "$ARCLABS_LOG" 2>&1; then
            show_success "base-devel installed"
            log_success "base-devel installed"
        else
            show_warning "Could not install base-devel"
            log_warn "base-devel installation failed"
        fi
    else
        show_success "base-devel already installed"
        log_info "base-devel already present"
    fi

    # Check pacman keyring
    show_info "Verifying package signing keys..."
    if sudo pacman-key --init >> "$ARCLABS_LOG" 2>&1 && \
       sudo pacman-key --populate archlinuxarm >> "$ARCLABS_LOG" 2>&1; then
        show_success "Package signing keys ready"
        log_success "Pacman keyring initialized"
    else
        show_warning "Keyring setup had issues (may affect package verification)"
        log_warn "Pacman keyring setup returned non-zero"
    fi
}
