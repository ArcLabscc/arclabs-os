#!/bin/bash
#
# ArcLabs OS Installer - Timezone Configuration
# Set timezone if still UTC
#

config_timezone() {
    show_section "Checking Timezone"

    local current_tz=$(timedatectl show -p Timezone --value 2>/dev/null || echo "unknown")

    if [[ "$current_tz" == "UTC" ]] || [[ "$current_tz" == "Etc/UTC" ]]; then
        show_warning "Timezone is currently UTC"
        log_warn "Timezone is UTC"

        echo ""
        echo "You should set your timezone. Common options:"
        echo ""
        echo "  America/Los_Angeles   (Pacific Time)"
        echo "  America/New_York      (Eastern Time)"
        echo "  America/Chicago       (Central Time)"
        echo "  Europe/London         (UK)"
        echo "  Europe/Berlin         (Central Europe)"
        echo "  Asia/Tokyo            (Japan)"
        echo ""
        echo "Set with: sudo timedatectl set-timezone TIMEZONE"
        echo ""
        echo "Example:"
        echo "  sudo timedatectl set-timezone America/Los_Angeles"
        echo ""
    else
        show_success "Timezone: $current_tz"
        log_info "Timezone already set: $current_tz"
    fi

    # Enable NTP sync
    if ! timedatectl show -p NTP --value 2>/dev/null | grep -qi "yes"; then
        show_info "Enabling NTP time sync..."
        if sudo timedatectl set-ntp true >> "$ARCLABS_LOG" 2>&1; then
            show_success "NTP enabled"
            log_success "NTP time sync enabled"
        else
            log_warn "Could not enable NTP"
        fi
    else
        log_info "NTP already enabled"
    fi
}
