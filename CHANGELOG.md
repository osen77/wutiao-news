# Changelog

## 0.1.2

- Sanitize openclaw.json on install: remove invalid fields (e.g. `path`) that cause gateway config validation failure
- Update README to document correct `skills.entries` schema and warn against unknown fields

## 0.1.1

- Switch token injection from `.env` file to `openclaw.json` env config (auto-injected at runtime)
- Update install.sh to write token into `openclaw.json` instead of `.env`
- Auto-migrate legacy `.env` token on reinstall

## 0.1.0

- Initial public release
- Curated and personalized digest modes
- Feishu card rendering
- Subscription management
- Article submission and comments
- Interest tag learning
- Self-updating mechanism
