#!/bin/bash
#
# ArcLabs OS Installer - AUR Package Installation
# Install packages from Arch User Repository
#

install_aur_packages() {
    show_section "Installing AUR Packages"

    # Check for AUR helper
    if [[ -z "$ARCLABS_AUR_HELPER" ]]; then
        show_warning "No AUR helper found - skipping AUR packages"
        log_warn "Skipping AUR packages (no helper available)"
        echo "Install yay or paru to enable AUR packages:"
        echo "  git clone https://aur.archlinux.org/yay-bin.git"
        echo "  cd yay-bin && makepkg -si"
        return 0
    fi

    local package_file="$ARCLABS_INSTALL/arclabs-aur.packages"

    if [[ ! -f "$package_file" ]]; then
        log_error "AUR package file not found: $package_file"
        show_error "AUR package list missing!"
        return 1
    fi

    # Count packages
    local total=$(grep -v '^#' "$package_file" | grep -v '^$' | wc -l)
    show_info "Installing $total packages from AUR using $ARCLABS_AUR_HELPER..."
    log_info "Installing $total AUR packages with $ARCLABS_AUR_HELPER"

    # Read packages into array
    local packages=()
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        packages+=("$line")
    done < "$package_file"

    # Install with chosen helper
    local failed_packages=()

    for pkg in "${packages[@]}"; do
        show_info "Installing $pkg..."
        if $ARCLABS_AUR_HELPER -S --needed --noconfirm "$pkg" >> "$ARCLABS_LOG" 2>&1; then
            log_success "Installed: $pkg"
        else
            log_warn "Failed to install: $pkg"
            failed_packages+=("$pkg")
        fi
    done

    if [[ ${#failed_packages[@]} -eq 0 ]]; then
        show_success "All AUR packages installed"
        log_success "AUR packages installed successfully"
    else
        show_warning "Some AUR packages failed: ${failed_packages[*]}"
        log_warn "Failed AUR packages: ${failed_packages[*]}"
        echo "You may need to install these manually:"
        for pkg in "${failed_packages[@]}"; do
            echo "  $ARCLABS_AUR_HELPER -S $pkg"
        done
    fi
}
