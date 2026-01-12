#!/bin/bash
#
# ArcLabs OS Installer - Environment Display
# Show system information before installation
#

preflight_show_env() {
    show_section "System Information"

    # CPU info
    local cpu_model=$(lscpu 2>/dev/null | grep "Model name" | cut -d: -f2 | xargs || echo "Unknown")
    local cpu_cores=$(nproc 2>/dev/null || echo "?")
    show_info "CPU: $cpu_model ($cpu_cores cores)"
    log_info "CPU: $cpu_model ($cpu_cores cores)"

    # Memory
    local mem_total=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo "Unknown")
    show_info "Memory: $mem_total"
    log_info "Memory: $mem_total"

    # Disk
    local disk_info=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $2 " total, " $4 " available"}' || echo "Unknown")
    show_info "Disk: $disk_info"
    log_info "Disk: $disk_info"

    # Kernel
    local kernel=$(uname -r)
    show_info "Kernel: $kernel"
    log_info "Kernel: $kernel"

    # GPU (Apple Silicon specific)
    if [[ -d /sys/class/drm ]]; then
        local gpu=$(cat /sys/class/drm/card*/device/uevent 2>/dev/null | grep -m1 "DRIVER" | cut -d= -f2 || echo "")
        if [[ -n "$gpu" ]]; then
            show_info "GPU: $gpu"
            log_info "GPU: $gpu"
        fi
    fi

    # Apple Silicon chip detection
    if [[ -f /sys/firmware/devicetree/base/compatible ]]; then
        local chip=$(cat /sys/firmware/devicetree/base/compatible 2>/dev/null | tr '\0' '\n' | grep -E "apple,(t|m)[0-9]" | head -1 || echo "")
        if [[ -n "$chip" ]]; then
            show_info "Apple Silicon: $chip"
            log_info "Apple Silicon: $chip"
        fi
    fi

    # User info
    echo ""
    show_info "User: $USER"
    show_info "Home: $HOME"
    show_info "Shell: $SHELL"

    log_info "User: $USER, Home: $HOME, Shell: $SHELL"
}
