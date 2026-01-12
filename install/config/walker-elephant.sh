#!/bin/bash
#
# ArcLabs OS Installer - Walker + Elephant Setup
# Configure app launcher with plugins
#

config_walker_elephant() {
    show_section "Configuring App Launcher"

    local autostart_dir="$HOME/.config/autostart"
    mkdir -p "$autostart_dir"

    # Walker autostart
    show_info "Creating Walker autostart..."
    cat > "$autostart_dir/walker.desktop" << 'WALKEREOF'
[Desktop Entry]
Type=Application
Name=Walker
Comment=Application launcher daemon
Exec=walker --gapplication-service
NoDisplay=true
X-GNOME-Autostart-enabled=true
WALKEREOF
    show_success "Walker autostart created"
    log_success "Walker autostart desktop entry created"

    # Elephant autostart
    show_info "Creating Elephant autostart..."
    cat > "$autostart_dir/elephant.desktop" << 'ELEPHANTEOF'
[Desktop Entry]
Type=Application
Name=Elephant
Comment=Walker plugin provider
Exec=elephant
NoDisplay=true
X-GNOME-Autostart-enabled=true
ELEPHANTEOF
    show_success "Elephant autostart created"
    log_success "Elephant autostart desktop entry created"

    # Enable elephant systemd service if available
    if systemctl --user cat elephant.service &> /dev/null; then
        show_info "Enabling Elephant systemd service..."
        if systemctl --user enable elephant.service >> "$ARCLABS_LOG" 2>&1; then
            show_success "Elephant service enabled"
            log_success "Elephant systemd service enabled"
        else
            log_warn "Could not enable elephant service"
        fi
    else
        log_info "Elephant systemd service not found (will use autostart)"
    fi

    # Check if Walker config exists, create default if not
    local walker_config="$HOME/.config/walker/config.toml"
    if [[ ! -f "$walker_config" ]]; then
        mkdir -p "$(dirname "$walker_config")"
        # Walker will create default config on first run
        log_info "Walker will create default config on first run"
    fi

    show_success "App launcher configuration complete"
}
