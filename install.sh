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

echo "📦 Downloading gog CLI..."
curl -L "$URL" -o /tmp/gog

chmod +x /tmp/gog

# Try to install to /usr/local/bin (requires sudo)
if [ -w /usr/local/bin ]; then
  mv /tmp/gog /usr/local/bin/gog
  echo "✅ Installed gog to /usr/local/bin/gog"
else
  echo "🔐 Installing to /usr/local/bin requires sudo..."
  sudo mv /tmp/gog /usr/local/bin/gog
  echo "✅ Installed gog to /usr/local/bin/gog"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Get started:"
echo "  gog auth add your-email@gmail.com"
echo ""
echo "For help:"
echo "  gog --help"
