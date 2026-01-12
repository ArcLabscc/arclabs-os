#!/bin/bash
#
# ArcLabs OS Installer - Guard Checks
# Pre-installation validation
#

preflight_guard() {
    show_section "Pre-flight Checks"

    # Check architecture
    local arch=$(uname -m)
    if [[ "$arch" != "aarch64" ]]; then
        show_error "ArcLabs OS requires ARM64 (aarch64)"
        log_error "Wrong architecture: $arch (expected aarch64)"
        echo "This distribution is designed for Apple Silicon Macs running Asahi Linux."
        return 1
    fi
    show_success "Architecture: ARM64 (aarch64)"
    log_info "Architecture check passed: $arch"

    # Check not root
    if [[ $EUID -eq 0 ]]; then
        show_error "Do not run as root"
        log_error "Script run as root"
        echo "Please run without sudo. The installer will ask for elevated privileges when needed."
        return 1
    fi
    show_success "Running as user: $USER"
    log_info "User check passed: $USER"

    # Check for AUR helper
    local aur_helper=""
    if command -v yay &> /dev/null; then
        aur_helper="yay"
    elif command -v paru &> /dev/null; then
        aur_helper="paru"
    fi

    if [[ -z "$aur_helper" ]]; then
        show_warning "No AUR helper found"
        log_warn "No AUR helper (yay/paru) found - AUR packages will be skipped"
        echo "Some features require AUR packages. Install yay or paru first:"
        echo "  git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si"
    else
        show_success "AUR helper: $aur_helper"
        log_info "AUR helper found: $aur_helper"
        export ARCLABS_AUR_HELPER="$aur_helper"
    fi

    # Check disk space (need at least 5GB)
    local available_gb=$(df -BG "$HOME" | awk 'NR==2 {print int($4)}')
    if [[ $available_gb -lt 5 ]]; then
        show_error "Insufficient disk space: ${available_gb}GB available (need 5GB)"
        log_error "Disk space check failed: ${available_gb}GB < 5GB"
        return 1
    fi
    show_success "Disk space: ${available_gb}GB available"
    log_info "Disk space check passed: ${available_gb}GB"

    # Check for Asahi Linux indicators
    if [[ -d /sys/firmware/devicetree/base/chosen/asahi,* ]] || \
       grep -qi "asahi" /etc/os-release 2>/dev/null || \
       [[ -f /etc/asahi-release ]]; then
        show_success "Asahi Linux detected"
        log_info "Running on Asahi Linux"
        export ARCLABS_IS_ASAHI=1
    else
        show_warning "Asahi Linux not detected"
        log_warn "Not running on Asahi Linux - some hardware features may not work"
        export ARCLABS_IS_ASAHI=0
    fi

    echo ""
    show_success "All pre-flight checks passed!"
    log_success "Pre-flight checks completed"
}
