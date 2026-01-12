#!/bin/bash
#
# ArcLabs OS Installer - Apple Keyboard Configuration
# Swap Cmd/Opt for better Mac-like experience
#

hardware_apple_keyboard() {
    show_info "Configuring Apple keyboard..."

    # Only configure if hid_apple module is present
    if [[ ! -d /sys/module/hid_apple ]]; then
        log_info "hid_apple module not loaded - skipping keyboard config"
        return 0
    fi

    local modprobe_conf="/etc/modprobe.d/hid_apple.conf"

    # Check if already configured
    if [[ -f "$modprobe_conf" ]] && grep -q "swap_opt_cmd=1" "$modprobe_conf"; then
        show_info "Apple keyboard already configured"
        log_info "hid_apple.conf already has swap_opt_cmd"
        return 0
    fi

    show_info "Setting up Cmd/Opt swap and function keys..."

    # Create modprobe configuration
    # swap_opt_cmd=1: Swap Option (Alt) and Command (Super) keys
    # fnmode=2: F1-F12 default to function keys (hold Fn for media)
    echo "options hid_apple swap_opt_cmd=1 fnmode=2" | \
        sudo tee "$modprobe_conf" > /dev/null

    log_info "Created $modprobe_conf"

    # Update initramfs so changes persist
    show_info "Updating initramfs..."
    if sudo mkinitcpio -P >> "$ARCLABS_LOG" 2>&1; then
        show_success "Apple keyboard configured"
        log_success "Apple keyboard: swap_opt_cmd=1 fnmode=2"
    else
        show_warning "Initramfs update had issues (changes may not persist after reboot)"
        log_warn "mkinitcpio returned non-zero"
    fi

    # Apply immediately without reboot
    echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd > /dev/null 2>&1 || true
    echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode > /dev/null 2>&1 || true

    # Set up keyboard backlight
    if [[ -d /sys/class/leds/kbd_backlight ]]; then
        show_info "Configuring keyboard backlight..."

        # Copy udev rule for persistence and permissions
        local repo_root="$(dirname "$ARCLABS_INSTALL")"
        if [[ -f "$repo_root/system/udev/99-kbd-backlight.rules" ]]; then
            sudo cp "$repo_root/system/udev/99-kbd-backlight.rules" /etc/udev/rules.d/
            sudo udevadm control --reload-rules 2>/dev/null || true
            log_info "Installed keyboard backlight udev rules"
        fi

        # Enable now
        sudo chmod 666 /sys/class/leds/kbd_backlight/brightness 2>/dev/null || true
        echo 128 > /sys/class/leds/kbd_backlight/brightness 2>/dev/null || true
        show_success "Keyboard backlight enabled"
        log_success "Keyboard backlight: brightness=128, persistence configured"
    fi
}
