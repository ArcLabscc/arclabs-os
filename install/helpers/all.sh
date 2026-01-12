#!/bin/bash
#
# ArcLabs OS Installer - All Helpers
# Sources all helper modules
#

HELPERS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$HELPERS_DIR/presentation.sh"
source "$HELPERS_DIR/logging.sh"
source "$HELPERS_DIR/errors.sh"
source "$HELPERS_DIR/run.sh"

# Initialize on load
init_logging
setup_error_handling
