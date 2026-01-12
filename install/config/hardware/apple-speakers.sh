#!/bin/bash
#
# ArcLabs OS Installer - Apple Speakers Configuration
# Asahi DSP and speaker safety
#

hardware_apple_speakers() {
    show_info "Configuring Apple speakers..."

    # Check for Asahi audio setup
    if [[ "$ARCLABS_IS_ASAHI" != "1" ]]; then
        log_info "Not on Asahi Linux - skipping speaker config"
        return 0
    fi

    # Check if speakersafetyd is available
    if command -v speakersafetyd &> /dev/null; then
        show_info "Enabling speaker safety daemon..."

        if systemctl --user enable speakersafetyd.service >> "$ARCLABS_LOG" 2>&1; then
            show_success "Speaker safety enabled"
            log_success "speakersafetyd.service enabled"
        else
            log_warn "Could not enable speakersafetyd (may not be available)"
        fi
    fi

    # PipeWire configuration for Apple speakers
    local pipewire_dir="$HOME/.config/pipewire/pipewire.conf.d"
    mkdir -p "$pipewire_dir"

    # Check for existing Asahi audio config
    if [[ ! -f "$pipewire_dir/99-asahi-audio.conf" ]]; then
        show_info "Creating PipeWire config for Apple audio..."

        cat > "$pipewire_dir/99-asahi-audio.conf" << 'PIPEEOF'
# Apple Silicon audio configuration
# Works with Asahi Linux audio support

context.properties = {
    # Higher quality resampling for Apple DAC
    default.clock.rate = 48000
    default.clock.allowed-rates = [ 44100 48000 ]
}

context.modules = [
    { name = libpipewire-module-rt
        args = {
            nice.level = -11
        }
        flags = [ ifexists nofail ]
    }
]
PIPEEOF
        log_success "Created PipeWire config for Apple audio"
    else
        log_info "PipeWire Asahi config already exists"
    fi

    show_success "Apple speakers configured"
}
