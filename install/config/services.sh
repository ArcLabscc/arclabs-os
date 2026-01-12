#!/bin/bash
#
# ArcLabs OS Installer - Services Setup
# Enable and configure system services
#

config_services() {
    log_step "Configuring system services"

    # === System Services (require sudo) ===
    local system_services=(
        "bluetooth.service"
        "docker.service"
        "avahi-daemon.service"
        "cups.service"
        "tailscaled.service"
        "NetworkManager.service"
        "speakersafetyd.service"
    )

    for service in "${system_services[@]}"; do
        if systemctl list-unit-files "$service" &>/dev/null; then
            if ! systemctl is-enabled "$service" &>/dev/null; then
                log_info "Enabling $service..."
                run_cmd "sudo systemctl enable $service" || log_warn "Failed to enable $service"
            else
                log_info "$service already enabled"
            fi
        fi
    done

    # === User Services (no sudo) ===
    local user_services=(
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
    )

    for service in "${user_services[@]}"; do
        if systemctl --user list-unit-files "$service" &>/dev/null; then
            if ! systemctl --user is-enabled "$service" &>/dev/null; then
                log_info "Enabling user service $service..."
                systemctl --user enable "$service" 2>/dev/null || log_warn "Failed to enable $service"
            fi
        fi
    done

    # === Docker group ===
    if getent group docker &>/dev/null; then
        if ! groups "$USER" | grep -q docker; then
            log_info "Adding $USER to docker group..."
            run_cmd "sudo usermod -aG docker $USER" || log_warn "Failed to add user to docker group"
        fi
    fi

    # === UFW Firewall (optional) ===
    if command -v ufw &>/dev/null; then
        if ! sudo ufw status | grep -q "Status: active"; then
            log_info "Configuring UFW firewall..."
            run_cmd "sudo ufw default deny incoming"
            run_cmd "sudo ufw default allow outgoing"
            run_cmd "sudo ufw allow ssh"
            # Don't enable by default - user can enable manually
            log_info "UFW configured but not enabled. Run 'sudo ufw enable' to activate."
        fi
    fi

    log_success "Services configured"
}
