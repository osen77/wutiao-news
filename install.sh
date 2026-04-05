#!/usr/bin/env bash
# Install wutiao-news skill for OpenClaw
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/nickelc/wutiao-news/main/install.sh | bash
#   curl -fsSL ... | bash -s -- /custom/path/to/wutiao-news

set -euo pipefail

REPO_URL="https://github.com/osen77/wutiao-news.git"
DEFAULT_DIR="$HOME/.openclaw/skills/wutiao-news"
INSTALL_DIR="${1:-$DEFAULT_DIR}"

echo "Installing wutiao-news to $INSTALL_DIR ..."

if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Already installed (git repo found). Pulling latest..."
    git -C "$INSTALL_DIR" pull --ff-only origin main
else
    if [ -d "$INSTALL_DIR" ]; then
        echo "Error: $INSTALL_DIR already exists but is not a git repo."
        echo "Remove it first or specify a different path."
        exit 1
    fi
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

# Create user prompt from default template (if not exists)
DEFAULT_PROMPT="$INSTALL_DIR/references/personalized-summary-prompt.default.md"
USER_PROMPT="$INSTALL_DIR/references/personalized-summary-prompt.md"
if [ -f "$DEFAULT_PROMPT" ] && [ ! -f "$USER_PROMPT" ]; then
    cp "$DEFAULT_PROMPT" "$USER_PROMPT"
    echo "Created customizable prompt: references/personalized-summary-prompt.md"
fi

echo ""
echo "Done! wutiao-news $(cat "$INSTALL_DIR/VERSION" | tr -d '[:space:]') installed."
echo ""
echo "The skill will auto-update on each use."
echo "Customize your summary prompt: $INSTALL_DIR/references/personalized-summary-prompt.md"
