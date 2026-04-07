#!/usr/bin/env bash
# Install wutiao-news skill for OpenClaw
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/osen77/wutiao-news/main/install.sh | bash
#   curl -fsSL ... | bash -s -- /custom/path/to/wutiao-news

set -euo pipefail

REPO_URL="https://github.com/osen77/wutiao-news.git"
DEFAULT_DIR="$HOME/.openclaw/skills/wutiao-news"
INSTALL_DIR="${1:-$DEFAULT_DIR}"
OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

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

# Configure token in openclaw.json (auto-injected as env var at runtime)
configure_token() {
    local token="$1"

    if [ ! -f "$OPENCLAW_JSON" ]; then
        echo "Warning: $OPENCLAW_JSON not found. Cannot auto-configure token."
        echo "Manually add to openclaw.json → skills.entries.wutiao-news.env.WUTIAO_TOKEN"
        return 1
    fi

    # Use python3 to safely merge into openclaw.json (handles missing keys)
    python3 -c "
import json, sys

path = '$OPENCLAW_JSON'
token = '$token'

with open(path, 'r') as f:
    cfg = json.load(f)

cfg.setdefault('skills', {}).setdefault('entries', {}).setdefault('wutiao-news', {}).setdefault('env', {})
cfg['skills']['entries']['wutiao-news']['env']['WUTIAO_TOKEN'] = token

with open(path, 'w') as f:
    json.dump(cfg, f, indent=2, ensure_ascii=False)
    f.write('\n')

print('Token configured in openclaw.json')
" || {
        echo "Warning: Failed to write openclaw.json. Set it manually:"
        echo "  openclaw.json → skills.entries.wutiao-news.env.WUTIAO_TOKEN"
        return 1
    }
}

# Check if token already configured in openclaw.json
EXISTING_TOKEN=""
if [ -f "$OPENCLAW_JSON" ]; then
    EXISTING_TOKEN=$(python3 -c "
import json
with open('$OPENCLAW_JSON') as f:
    cfg = json.load(f)
print(cfg.get('skills',{}).get('entries',{}).get('wutiao-news',{}).get('env',{}).get('WUTIAO_TOKEN',''))
" 2>/dev/null || true)
fi

if [ -z "$EXISTING_TOKEN" ]; then
    # Migrate from legacy .env if exists
    ENV_FILE="$INSTALL_DIR/.env"
    if [ -f "$ENV_FILE" ] && grep -q "WUTIAO_TOKEN" "$ENV_FILE" 2>/dev/null; then
        LEGACY_TOKEN=$(grep "WUTIAO_TOKEN" "$ENV_FILE" | cut -d= -f2)
        if [ -n "$LEGACY_TOKEN" ]; then
            echo "Migrating token from .env to openclaw.json..."
            configure_token "$LEGACY_TOKEN"
        fi
    else
        echo ""
        read -rp "Enter your wutiao-news token (ask the admin for one): " TOKEN
        if [ -n "$TOKEN" ]; then
            configure_token "$TOKEN"
        else
            echo "Warning: No token configured. API calls will fail."
            echo "Set it later in openclaw.json → skills.entries.wutiao-news.env.WUTIAO_TOKEN"
        fi
    fi
else
    echo "Token already configured in openclaw.json."
fi

echo ""
echo "Done! wutiao-news $(cat "$INSTALL_DIR/VERSION" | tr -d '[:space:]') installed."
echo ""
echo "The skill will auto-update on each use."
echo "Customize your summary prompt: $INSTALL_DIR/references/personalized-summary-prompt.md"
