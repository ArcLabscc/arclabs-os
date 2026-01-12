#!/bin/bash
#
# ArcLabs OS Installer - Config Module
# All configuration setup
#

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CONFIG_DIR/install-files.sh"
source "$CONFIG_DIR/user-config.sh"
source "$CONFIG_DIR/theme.sh"
source "$CONFIG_DIR/path.sh"
source "$CONFIG_DIR/walker-elephant.sh"
source "$CONFIG_DIR/hyprland-env.sh"
source "$CONFIG_DIR/groups.sh"
source "$CONFIG_DIR/timezone.sh"
source "$CONFIG_DIR/plymouth.sh"
source "$CONFIG_DIR/branding.sh"
source "$CONFIG_DIR/services.sh"

# Also source hardware sub-module if present
if [[ -f "$CONFIG_DIR/hardware/all.sh" ]]; then
    source "$CONFIG_DIR/hardware/all.sh"
fi

# Run all configuration
run_config() {
    set_phase "config"

    config_install_files
    config_user_config
    config_theme
    config_path
    config_walker_elephant
    config_hyprland_env
    config_groups
    config_timezone
    config_plymouth
    config_branding
    config_services

    # Run hardware config if available
    if declare -f run_hardware_config > /dev/null; then
        run_hardware_config
    fi

    log_success "Config module completed"
}
