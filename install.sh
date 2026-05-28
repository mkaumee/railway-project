#!/usr/bin/env bash
set -e

REPO="mkaumee/gog-cli"
VERSION="latest"

OS="$(uname -s)"
ARCH="$(uname -m)"

if [[ "$OS" == "Darwin" ]]; then
  if [[ "$ARCH" == "arm64" ]]; then
    FILE="gog-darwin-arm64"
  else
    FILE="gog-darwin-amd64"
  fi
elif [[ "$OS" == "Linux" ]]; then
  FILE="gog-linux-amd64"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

URL="https://github.com/$REPO/releases/latest/download/$FILE"

# Install to a user folder — no sudo required, works on fresh Apple Silicon
# Macs where /usr/local/bin may not exist.
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
DEST="$INSTALL_DIR/gog"

echo "📦 Downloading gog CLI..."
curl -fL "$URL" -o "$DEST"
chmod +x "$DEST"

# Strip macOS quarantine flag so Gatekeeper does not block first execution
# of the unsigned binary downloaded via curl.
if [[ "$OS" == "Darwin" ]]; then
  xattr -d com.apple.quarantine "$DEST" 2>/dev/null || true
fi

echo "✅ Installed gog to $DEST"

# Make sure ~/.local/bin is on PATH for future shells. Pick the first existing
# rc file so we update one and stop, instead of polluting all of them.
case ":$PATH:" in
  *":$INSTALL_DIR:"*)
    ;;
  *)
    for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
      [ -f "$rc" ] || continue
      grep -q "$INSTALL_DIR" "$rc" 2>/dev/null && break
      printf '\n# Added by gog installer\nexport PATH="%s:$PATH"\n' "$INSTALL_DIR" >> "$rc"
      echo "✅ Added $INSTALL_DIR to PATH in $rc"
      break
    done
    ;;
esac

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Get started:"
echo "  gog auth add your-email@gmail.com"
echo ""
echo "For help:"
echo "  gog --help"
echo ""
echo "Note: Open a new terminal so the PATH update takes effect."
