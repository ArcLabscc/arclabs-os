#!/bin/bash
#
# ArcLabs OS Installer - Finished
# Success message and next steps
#

post_finished() {
    show_complete

    echo ""
    echo -e "${GREEN}Installation completed successfully!${NC}"
    echo ""

    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo "  1. Log out of your current session"
    echo "  2. At the SDDM login screen, select:"
    echo -e "     ${CYAN}Hyprland (uwsm-managed)${NC}"
    echo "  3. Log in with your password"
    echo ""

    echo -e "${BOLD}Key Bindings:${NC}"
    echo ""
    echo "  Super + Return       Open terminal (kitty)"
    echo "  Super + Space        App launcher (Walker)"
    echo "  Super + W            Close window"
    echo "  Super + 1-9          Switch workspace"
    echo "  Super + Shift + 1-9  Move window to workspace"
    echo "  Super + F            Toggle fullscreen"
    echo "  Super + V            Toggle floating"
    echo "  Super + Shift + B    Open browser"
    echo ""

    echo -e "${BOLD}Useful Commands:${NC}"
    echo ""
    echo "  arclabs-change-bg    Change wallpaper"
    echo "  arclabs-change-theme Change theme"
    echo "  arclabs-restart      Restart desktop"
    echo ""

    echo -e "${DIM}Installation log: $ARCLABS_LOG${NC}"
    echo ""

    log_success "Installation finished successfully"
    log "=== Installation Complete ==="
    log "End time: $(date '+%Y-%m-%d %H:%M:%S')"
}
