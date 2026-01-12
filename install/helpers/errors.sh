#!/bin/bash
#
# ArcLabs OS Installer - Error Handling
# Graceful error recovery and reporting
#

# Track installation state for cleanup
export ARCLABS_INSTALL_PHASE=""
export ARCLABS_INSTALL_STARTED=0

# Error handler - called on script errors
_error_handler() {
    local exit_code=$?
    local line_no=$1
    local command="${BASH_COMMAND}"

    echo ""
    show_error "Installation failed!"
    echo ""
    echo -e "${RED}Error Details:${NC}"
    echo "  Exit code: $exit_code"
    echo "  Line: $line_no"
    echo "  Command: $command"
    [[ -n "$ARCLABS_INSTALL_PHASE" ]] && echo "  Phase: $ARCLABS_INSTALL_PHASE"

    log_error "Installation failed at line $line_no: $command (exit $exit_code)"

    # Show log tail for debugging
    show_log_tail 20

    echo ""
    echo -e "${YELLOW}Need help?${NC}"
    echo "  • Check the full log: $ARCLABS_LOG"
    echo "  • Report issues: https://github.com/arclabscc/arclabs-os/issues"
    echo ""

    exit $exit_code
}

# Set up error trapping
setup_error_handling() {
    set -eE
    trap '_error_handler ${LINENO}' ERR
}

# Set current installation phase (for error context)
set_phase() {
    export ARCLABS_INSTALL_PHASE="$1"
    log_info "Entering phase: $1"
}

# Check if command exists
require_command() {
    local cmd=$1
    local pkg=${2:-$1}
    if ! command -v "$cmd" &> /dev/null; then
        log_error "Required command not found: $cmd"
        echo "Please install: $pkg"
        return 1
    fi
}

# Require running as non-root
require_not_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        echo "Please run without sudo. The script will ask for sudo when needed."
        exit 1
    fi
}

# Check minimum disk space (in GB)
require_disk_space() {
    local required_gb=${1:-5}
    local available_gb=$(df -BG "$HOME" | awk 'NR==2 {print int($4)}')

    if [[ $available_gb -lt $required_gb ]]; then
        log_error "Insufficient disk space: ${available_gb}GB available, ${required_gb}GB required"
        return 1
    fi
    log_info "Disk space check passed: ${available_gb}GB available"
}
