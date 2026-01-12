#!/bin/bash
#
# ArcLabs OS Installer - Login Module
# Display manager and session setup
#

LOGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$LOGIN_DIR/sddm.sh"
source "$LOGIN_DIR/uwsm.sh"

# Run all login configuration
run_login() {
    set_phase "login"

    show_section "Login & Session Setup"

    login_sddm
    login_uwsm

    show_success "Login configuration complete"
    log_success "Login module completed"
}
