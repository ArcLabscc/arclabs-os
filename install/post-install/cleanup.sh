#!/bin/bash
#
# ArcLabs OS Installer - Cleanup
# Post-installation cleanup tasks
#

post_cleanup() {
    show_info "Cleaning up..."

    # Clean pacman cache (keep only one version)
    show_info "Cleaning package cache..."
    if sudo paccache -rk1 >> "$ARCLABS_LOG" 2>&1; then
        log_success "Cleaned pacman cache"
    else
        log_info "paccache not available or no cleanup needed"
    fi

    # Clean AUR helper cache
    if [[ -n "$ARCLABS_AUR_HELPER" ]]; then
        case "$ARCLABS_AUR_HELPER" in
            yay)
                yay -Scc --noconfirm >> "$ARCLABS_LOG" 2>&1 || true
                ;;
            paru)
                paru -Scc --noconfirm >> "$ARCLABS_LOG" 2>&1 || true
                ;;
        esac
        log_info "Cleaned $ARCLABS_AUR_HELPER cache"
    fi

    # Remove any temp files
    rm -f /tmp/arclabs-install-* 2>/dev/null || true

    show_success "Cleanup complete"
    log_success "Post-install cleanup completed"
}
