#!/bin/bash
#
# ArcLabs OS Installer - User Groups
# Add user to required system groups
#

config_groups() {
    show_section "Configuring User Groups"

    local groups_to_add=(
        "input"     # Input devices (keyboard, mouse, touchpad)
        "video"     # Video devices (brightness control)
        "audio"     # Audio devices
    )

    # Seat group (for login sessions)
    if getent group seat > /dev/null 2>&1; then
        groups_to_add+=("seat")
    fi

    # Wheel group (for sudo)
    if getent group wheel > /dev/null 2>&1; then
        if ! groups "$USER" | grep -qw wheel; then
            groups_to_add+=("wheel")
        fi
    fi

    for group in "${groups_to_add[@]}"; do
        if getent group "$group" > /dev/null 2>&1; then
            if groups "$USER" | grep -qw "$group"; then
                show_info "Already in group: $group"
                log_info "User already in group: $group"
            else
                show_info "Adding user to group: $group"
                if sudo usermod -aG "$group" "$USER" >> "$ARCLABS_LOG" 2>&1; then
                    show_success "Added to group: $group"
                    log_success "Added user to group: $group"
                else
                    show_warning "Could not add to group: $group"
                    log_warn "Failed to add user to group: $group"
                fi
            fi
        else
            log_info "Group does not exist: $group"
        fi
    done

    show_info "Group changes take effect after logout"
    show_success "User groups configured"
}
