#!/usr/bin/env bash
set -e

echo "🗑️  Uninstalling gog CLI..."

# Remove binary
if [ -f "/usr/local/bin/gog" ]; then
    echo "Removing /usr/local/bin/gog..."
    if [ -w /usr/local/bin ]; then
        rm /usr/local/bin/gog
    else
        sudo rm /usr/local/bin/gog
    fi
    echo "✅ Binary removed"
else
    echo "⚠️  Binary not found at /usr/local/bin/gog"
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
