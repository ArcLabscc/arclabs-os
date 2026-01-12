#!/bin/bash
#
# ArcLabs OS Installer - Apple WiFi Configuration
# Check Broadcom firmware status
#

hardware_apple_wifi() {
    show_info "Checking Apple WiFi..."

    # Check if we're on Asahi
    if [[ "$ARCLABS_IS_ASAHI" != "1" ]]; then
        log_info "Not on Asahi Linux - skipping WiFi check"
        return 0
    fi

    # Check for Broadcom WiFi interface
    local wifi_interface=$(ip link show 2>/dev/null | grep -E "wlan|wlp" | head -1 | cut -d: -f2 | tr -d ' ')

    if [[ -z "$wifi_interface" ]]; then
        show_warning "No WiFi interface found"
        log_warn "WiFi interface not detected"

        echo ""
        echo "WiFi firmware may need to be extracted. Try:"
        echo "  sudo asahi-fwextract"
        echo ""
        echo "Then reboot for WiFi to become available."
        return 0
    fi

    # Check if interface is up
    if ip link show "$wifi_interface" 2>/dev/null | grep -q "UP"; then
        show_success "WiFi interface active: $wifi_interface"
        log_success "WiFi interface up: $wifi_interface"
    else
        show_info "WiFi interface found: $wifi_interface (not active)"
        log_info "WiFi interface exists but not up: $wifi_interface"
    fi

    # Check firmware files
    local fw_dir="/lib/firmware/brcm"
    if [[ -d "$fw_dir" ]] && ls "$fw_dir"/*.bin &> /dev/null; then
        local fw_count=$(ls -1 "$fw_dir"/*.bin 2>/dev/null | wc -l)
        show_success "Broadcom firmware present ($fw_count files)"
        log_info "Broadcom firmware files found: $fw_count"
    else
        show_warning "Broadcom firmware may be missing"
        log_warn "Firmware directory empty or missing: $fw_dir"
        echo ""
        echo "Run 'sudo asahi-fwextract' if WiFi doesn't work."
    fi

    # Ensure NetworkManager is configured
    if systemctl is-enabled NetworkManager.service &> /dev/null; then
        show_info "NetworkManager enabled"
        log_info "NetworkManager service enabled"
    else
        show_info "Enabling NetworkManager..."
        if sudo systemctl enable NetworkManager.service >> "$ARCLABS_LOG" 2>&1; then
            show_success "NetworkManager enabled"
            log_success "NetworkManager service enabled"
        fi
    fi
}
