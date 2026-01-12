#!/bin/bash
#
# ArcLabs OS Installer - Post-Install Module
# Cleanup and completion
#

POSTINSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$POSTINSTALL_DIR/cleanup.sh"
source "$POSTINSTALL_DIR/ghostty.sh"
source "$POSTINSTALL_DIR/finished.sh"

# Run all post-install tasks
run_post_install() {
    set_phase "post-install"

    show_section "Finishing Up"

    post_cleanup
    post_ghostty
    post_finished

    log_success "Post-install module completed"
}
