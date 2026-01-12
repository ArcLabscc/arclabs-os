#!/bin/bash
#
# ArcLabs OS Installer - Logging Helpers
# File and console logging with timestamps
#

# Default log file location
export ARCLABS_LOG="${ARCLABS_LOG:-/tmp/arclabs-install.log}"

# Initialize log file
init_logging() {
    local log_dir=$(dirname "$ARCLABS_LOG")
    if [[ -w "$log_dir" ]] || sudo mkdir -p "$log_dir" 2>/dev/null; then
        sudo touch "$ARCLABS_LOG" 2>/dev/null || touch "$ARCLABS_LOG"
        sudo chmod 666 "$ARCLABS_LOG" 2>/dev/null || true
        echo "=== ArcLabs OS Installation Log ===" > "$ARCLABS_LOG"
        echo "Started: $(date '+%Y-%m-%d %H:%M:%S')" >> "$ARCLABS_LOG"
        echo "User: $USER" >> "$ARCLABS_LOG"
        echo "Host: $(hostname)" >> "$ARCLABS_LOG"
        echo "===================================" >> "$ARCLABS_LOG"
    fi
}

# Timestamp for log entries
_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Log to file only
log() {
    echo "[$(_timestamp)] $1" >> "$ARCLABS_LOG" 2>/dev/null || true
}

# Log info (file + optional console)
log_info() {
    log "[INFO] $1"
}

# Log warning (file + console)
log_warn() {
    log "[WARN] $1"
    show_warning "$1"
}

# Log error (file + console)
log_error() {
    log "[ERROR] $1"
    show_error "$1"
}

# Log command execution
log_cmd() {
    local cmd="$1"
    log "[CMD] $cmd"
}

# Log success
log_success() {
    log "[OK] $1"
}

# Show last N lines of log (for debugging)
show_log_tail() {
    local lines=${1:-20}
    if [[ -f "$ARCLABS_LOG" ]]; then
        echo ""
        echo -e "${DIM}Last $lines lines of install log:${NC}"
        tail -n "$lines" "$ARCLABS_LOG"
    fi
}
