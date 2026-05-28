#!/usr/bin/env bash
set -e

echo "🗑️  Uninstalling gog CLI..."

removed_any=0

# New install location (used by install.sh after the 2026-05 rewrite)
USER_BIN="$HOME/.local/bin/gog"
if [ -f "$USER_BIN" ]; then
    echo "Removing $USER_BIN..."
    rm "$USER_BIN"
    echo "✅ Binary removed"
    removed_any=1
fi

# Legacy install location (used by older install.sh, kept for cleanup)
SYS_BIN="/usr/local/bin/gog"
if [ -f "$SYS_BIN" ]; then
    echo "Removing $SYS_BIN..."
    if [ -w /usr/local/bin ]; then
        rm "$SYS_BIN"
    else
        sudo rm "$SYS_BIN"
    fi
    echo "✅ Legacy binary removed"
    removed_any=1
fi

if [ "$removed_any" -eq 0 ]; then
    echo "⚠️  No gog binary found at $USER_BIN or $SYS_BIN"
fi

# Ask about config/credentials
echo ""
read -p "Remove stored credentials and config? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Determine config directory
    if [ -n "$XDG_CONFIG_HOME" ]; then
        CONFIG_DIR="$XDG_CONFIG_HOME/gogcli"
    else
        CONFIG_DIR="$HOME/.config/gogcli"
    fi

    if [ -d "$CONFIG_DIR" ]; then
        echo "Removing $CONFIG_DIR..."
        rm -rf "$CONFIG_DIR"
        echo "✅ Config and credentials removed"
    else
        echo "⚠️  Config directory not found"
    fi
else
    echo "ℹ️  Keeping config and credentials"
fi

echo ""
echo "✅ Uninstall complete!"
