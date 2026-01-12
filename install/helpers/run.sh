#!/bin/bash
#
# ArcLabs OS Installer - Run Helpers
# Script execution with logging and error handling
#

# Run a command with logging
# Usage: run_logged "description" command args...
run_logged() {
    local desc="$1"
    shift
    local cmd="$*"

    log_cmd "$cmd"
    show_info "$desc"

    if eval "$cmd" >> "$ARCLABS_LOG" 2>&1; then
        log_success "$desc"
        return 0
    else
        local exit_code=$?
        log_error "$desc failed (exit $exit_code)"
        return $exit_code
    fi
}

# Run a command silently (log only, no console output)
run_silent() {
    local cmd="$*"
    log_cmd "$cmd"
    eval "$cmd" >> "$ARCLABS_LOG" 2>&1
}

# Run a command with visible output (for interactive commands)
run_visible() {
    local cmd="$*"
    log_cmd "$cmd"
    eval "$cmd" 2>&1 | tee -a "$ARCLABS_LOG"
    return ${PIPESTATUS[0]}
}

# Source another install script with phase tracking
source_module() {
    local module_path="$1"
    local module_name=$(basename "$module_path" .sh)

    if [[ -f "$module_path" ]]; then
        set_phase "$module_name"
        source "$module_path"
        log_success "Module completed: $module_name"
    else
        log_error "Module not found: $module_path"
        return 1
    fi
}

# Run a script as a subprocess
run_script() {
    local script_path="$1"
    shift
    local args="$*"

    if [[ -x "$script_path" ]]; then
        log_cmd "$script_path $args"
        "$script_path" $args
    else
        log_error "Script not found or not executable: $script_path"
        return 1
    fi
}
