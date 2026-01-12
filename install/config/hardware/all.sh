#!/bin/bash
#
# ArcLabs OS Installer - Hardware Module
# Apple Silicon specific configurations
#

HARDWARE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$HARDWARE_DIR/apple-keyboard.sh"
source "$HARDWARE_DIR/apple-trackpad.sh"
source "$HARDWARE_DIR/apple-speakers.sh"
source "$HARDWARE_DIR/apple-wifi.sh"
source "$HARDWARE_DIR/apple-gpu.sh"

# Run all hardware configuration
run_hardware_config() {
    set_phase "hardware"

    show_section "Apple Silicon Hardware"

    hardware_apple_keyboard
    hardware_apple_trackpad
    hardware_apple_speakers
    hardware_apple_wifi
    hardware_apple_gpu

    show_success "Hardware configuration complete"
    log_success "Hardware module completed"
}
