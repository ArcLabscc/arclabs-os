#!/bin/bash
#
# ArcLabs OS Installer - PATH Setup
# Configure shell PATH for ArcLabs OS scripts
#

config_path() {
    show_section "Configuring Shell PATH"

    local path_line='export PATH="$HOME/.local/share/arclabs-os/bin:$PATH"'
    local env_line='export ARCLABS_PATH="$HOME/.local/share/arclabs-os"'

    # Bash
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "arclabs-os/bin" "$HOME/.bashrc"; then
            show_info "Adding ArcLabs OS to ~/.bashrc..."
            cat >> "$HOME/.bashrc" << 'BASHEOF'

# ArcLabs OS
export ARCLABS_PATH="$HOME/.local/share/arclabs-os"
export PATH="$HOME/.local/share/arclabs-os/bin:$PATH"
BASHEOF
            show_success "Updated ~/.bashrc"
            log_success "Updated .bashrc with PATH"
        else
            show_info "~/.bashrc already configured"
            log_info ".bashrc already has arclabs-os PATH"
        fi
    fi

    # Zsh
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "arclabs-os/bin" "$HOME/.zshrc"; then
            show_info "Adding ArcLabs OS to ~/.zshrc..."
            cat >> "$HOME/.zshrc" << 'ZSHEOF'

# ArcLabs OS
export ARCLABS_PATH="$HOME/.local/share/arclabs-os"
export PATH="$HOME/.local/share/arclabs-os/bin:$PATH"
ZSHEOF
            show_success "Updated ~/.zshrc"
            log_success "Updated .zshrc with PATH"
        else
            show_info "~/.zshrc already configured"
            log_info ".zshrc already has arclabs-os PATH"
        fi
    fi

    # Fish
    if [[ -d "$HOME/.config/fish" ]]; then
        mkdir -p "$HOME/.config/fish/conf.d"
        if [[ ! -f "$HOME/.config/fish/conf.d/arclabs.fish" ]]; then
            show_info "Adding ArcLabs OS to fish config..."
            cat > "$HOME/.config/fish/conf.d/arclabs.fish" << 'FISHEOF'
if status is-interactive
    set -gx ARCLABS_PATH "$HOME/.local/share/arclabs-os"
    fish_add_path "$HOME/.local/share/arclabs-os/bin"
end
FISHEOF
            show_success "Created fish config"
            log_success "Created fish arclabs.fish"
        else
            show_info "Fish config already exists"
            log_info "Fish arclabs.fish already exists"
        fi
    fi

    show_success "Shell PATH configuration complete"
}
