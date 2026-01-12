#!/bin/bash
#
# Build Ghostty from source for ARM64
# Required because no pre-built ARM64 packages exist
#

set -e

GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${CYAN}Building Ghostty for ARM64...${NC}"

# Check dependencies
DEPS="zig gtk4 gtk4-layer-shell libadwaita blueprint-compiler pandoc pkg-config fontconfig freetype2"
echo "Checking dependencies..."
for dep in $DEPS; do
    if ! pacman -Q $dep &>/dev/null; then
        echo -e "${RED}Missing dependency: $dep${NC}"
        echo "Install with: sudo pacman -S $dep"
        exit 1
    fi
done

# Clone or update
GHOSTTY_DIR="/tmp/ghostty-build"
if [ -d "$GHOSTTY_DIR" ]; then
    echo "Updating existing clone..."
    cd "$GHOSTTY_DIR"
    git pull
else
    echo "Cloning ghostty..."
    git clone --depth 1 https://github.com/ghostty-org/ghostty.git "$GHOSTTY_DIR"
    cd "$GHOSTTY_DIR"
fi

# Build
echo "Building (this may take 5-10 minutes)..."
zig build -p "$HOME/.local" -Doptimize=ReleaseFast

# Verify
if [ -x "$HOME/.local/bin/ghostty" ]; then
    echo -e "${GREEN}Success! Ghostty installed to ~/.local/bin/ghostty${NC}"
    "$HOME/.local/bin/ghostty" --version
else
    echo -e "${RED}Build failed - ghostty not found${NC}"
    exit 1
fi
