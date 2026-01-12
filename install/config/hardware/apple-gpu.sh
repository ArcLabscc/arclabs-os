#!/bin/bash
#
# ArcLabs OS Installer - Apple GPU Configuration
# Detect M1/M2/M3 and configure renderer
#

hardware_apple_gpu() {
    show_info "Configuring Apple GPU..."

    # Check if we're on Asahi
    if [[ "$ARCLABS_IS_ASAHI" != "1" ]]; then
        log_info "Not on Asahi Linux - skipping GPU config"
        return 0
    fi

    # Detect Apple Silicon generation
    local chip=""
    if [[ -f /sys/firmware/devicetree/base/compatible ]]; then
        local compat=$(cat /sys/firmware/devicetree/base/compatible 2>/dev/null | tr '\0' '\n')

        if echo "$compat" | grep -q "apple,t600"; then
            chip="M1"
        elif echo "$compat" | grep -q "apple,t601"; then
            chip="M1 Pro"
        elif echo "$compat" | grep -q "apple,t602"; then
            chip="M1 Max"
        elif echo "$compat" | grep -q "apple,t603"; then
            chip="M1 Ultra"
        elif echo "$compat" | grep -q "apple,t810"; then
            chip="M2"
        elif echo "$compat" | grep -q "apple,t811"; then
            chip="M2 Pro"
        elif echo "$compat" | grep -q "apple,t812"; then
            chip="M2 Max"
        elif echo "$compat" | grep -q "apple,t813"; then
            chip="M2 Ultra"
        elif echo "$compat" | grep -q "apple,t814"; then
            chip="M3"
        elif echo "$compat" | grep -q "apple,t815"; then
            chip="M3 Pro"
        elif echo "$compat" | grep -q "apple,t816"; then
            chip="M3 Max"
        fi
    fi

    if [[ -n "$chip" ]]; then
        show_success "Detected: Apple $chip"
        log_info "Apple Silicon chip: $chip"
    fi

    # Check for Asahi GPU driver
    if lsmod | grep -q "asahi"; then
        show_success "Asahi GPU driver loaded"
        log_info "asahi kernel module loaded"
    else
        show_warning "Asahi GPU driver not loaded"
        log_warn "asahi kernel module not found"
    fi

    # Configure Hyprland for Apple GPU
    local hypr_misc="$HOME/.config/hypr/misc.conf"
    mkdir -p "$(dirname "$hypr_misc")"

    if [[ ! -f "$hypr_misc" ]] || ! grep -q "vfr\|vrr" "$hypr_misc"; then
        cat >> "$hypr_misc" << 'MISCEOF'

# Apple GPU optimizations
misc {
    # Variable refresh rate (ProMotion displays)
    vrr = 1

    # Variable frame rate (better power efficiency)
    vfr = true

    # Disable splash (faster startup)
    disable_hyprland_logo = true
    disable_splash_rendering = true
}
MISCEOF
        show_success "Hyprland GPU settings configured"
        log_success "Created Hyprland misc.conf for Apple GPU"
    else
        log_info "Hyprland misc.conf already has GPU settings"
    fi
}
