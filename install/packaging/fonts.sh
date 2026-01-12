#!/bin/bash
#
# ArcLabs OS Installer - Font Installation
# Install and configure fonts
#

install_fonts() {
    show_section "Installing Fonts"

    # Core font packages
    local font_packages=(
        "ttf-dejavu"
        "ttf-liberation"
        "noto-fonts"
        "noto-fonts-emoji"
    )

    show_info "Installing system fonts..."
    log_info "Installing font packages"

    for font in "${font_packages[@]}"; do
        if sudo pacman -S --needed --noconfirm "$font" >> "$ARCLABS_LOG" 2>&1; then
            log_success "Installed font: $font"
        else
            log_warn "Could not install font: $font"
        fi
    done

    # JetBrains Mono Nerd Font (from AUR if available)
    if [[ -n "$ARCLABS_AUR_HELPER" ]]; then
        show_info "Installing JetBrains Mono Nerd Font..."
        if $ARCLABS_AUR_HELPER -S --needed --noconfirm ttf-jetbrains-mono-nerd >> "$ARCLABS_LOG" 2>&1; then
            show_success "JetBrains Mono Nerd Font installed"
            log_success "JetBrains Mono Nerd Font installed"
        else
            show_warning "Could not install JetBrains Mono Nerd Font from AUR"
            log_warn "JetBrains Mono Nerd Font installation failed"
        fi
    fi

    # Update font cache
    show_info "Updating font cache..."
    if fc-cache -f >> "$ARCLABS_LOG" 2>&1; then
        show_success "Font cache updated"
        log_success "Font cache updated"
    else
        log_warn "Font cache update had issues"
    fi
}
