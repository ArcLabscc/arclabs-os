#!/bin/bash
#
# ArcLabs OS Installer - Apple Trackpad Configuration
# Natural scrolling, tap-to-click, gestures
#

hardware_apple_trackpad() {
    show_info "Configuring Apple trackpad..."

    # Check if we're on Apple hardware with trackpad
    if ! ls /sys/class/input/*/name 2>/dev/null | \
       xargs cat 2>/dev/null | grep -qi "apple\|magic"; then
        log_info "No Apple trackpad detected - skipping"
        return 0
    fi

    local libinput_dir="/etc/libinput"
    local quirks_dir="$libinput_dir/local-overrides.d"

    # Create libinput quirks for Apple trackpad
    sudo mkdir -p "$quirks_dir"

    show_info "Creating trackpad configuration..."

    # Apple Magic Trackpad / Internal Trackpad settings
    sudo tee "$quirks_dir/10-apple-trackpad.quirks" > /dev/null << 'QUIRKSEOF'
# Apple Trackpad settings for ArcLabs OS

[Apple Internal Trackpad]
MatchUdevType=touchpad
MatchName=*Apple*
AttrPressureRange=4:2

[Apple Magic Trackpad]
MatchUdevType=touchpad
MatchName=*Magic*
AttrPressureRange=4:2
QUIRKSEOF

    log_info "Created libinput quirks for Apple trackpad"

    # Hyprland input configuration
    local hypr_input="$HOME/.config/hypr/input.conf"

    if [[ ! -f "$hypr_input" ]] || ! grep -q "touchpad" "$hypr_input"; then
        mkdir -p "$(dirname "$hypr_input")"

        cat >> "$hypr_input" << 'INPUTEOF'

# Apple Trackpad Settings
input {
    touchpad {
        natural_scroll = true
        tap-to-click = true
        disable_while_typing = true
        clickfinger_behavior = true
        scroll_factor = 0.5
    }

    # Apple Magic Mouse (if used)
    scroll_method = 2fg
    accel_profile = adaptive
}

# Trackpad gestures
gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
    workspace_swipe_distance = 300
    workspace_swipe_invert = false
}
INPUTEOF
        show_success "Apple trackpad configured"
        log_success "Created Hyprland trackpad config"
    else
        show_info "Trackpad already configured in Hyprland"
        log_info "Hyprland input.conf already has touchpad settings"
    fi
}
