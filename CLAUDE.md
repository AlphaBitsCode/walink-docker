# CLAUDE.md

Guidance for AI coding assistants working with this repository.

## Overview

Dockerized fork of [whatsapp-web.js](https://github.com/pedroslopez/whatsapp-web.js) (v1.34.6) — a Node.js WhatsApp API client using Puppeteer to automate WhatsApp Web. Extended with MQTT integration and Docker/CasaOS deployment support by [Alpha Bits](https://alphabits.team).

**Upstream:** `pedroslopez/whatsapp-web.js` (remote: `upstream`)
**Fork:** `AlphaBitsCode/walink-docker` (remote: `origin`)

## Commands

```bash
npm test                              # Mocha tests (5s timeout)
npm run test-single                   # Single test file
npm install --legacy-peer-deps        # Required (jsdoc peer dep conflict)
docker build -t walink-docker .       # Build image
docker compose up -d                  # Run stack (walink + MQTT broker)
node main.js                          # Run locally
```

## Architecture

```
main.js                    # Entry point — MQTT bridge + WhatsApp event handlers
├── index.js               # Library exports
├── src/Client.js           # Core client (EventEmitter, Puppeteer automation)
├── src/structures/         # Data models: Chat, Message, Contact, GroupChat, etc.
├── src/authStrategies/     # LocalAuth (default), RemoteAuth, NoAuth
├── src/util/Constants.js   # WWeb version, user agent, timeouts
├── src/util/Injected/      # Browser-injected Store modules
├── src/factories/          # Entity object factories
└── src/webCache/           # Local/Remote web cache strategies
```

**Patterns:** Event-driven (EventEmitter), Puppeteer browser automation, Strategy pattern (auth), Factory pattern (entities)

## Key Config

| Env Var | Purpose |
|---|---|
| `DEVICE_NAME` | Custom device name in WA linked devices |
| `BROWSER_NAME` | Browser icon: Chrome, Firefox, Safari, Edge, Opera, IE |
| `MQTT_ENABLE` | Enable MQTT bridge (`true`/`false`) |
| `MQTT_BROKER_URL` | Broker URL (default: `mqtt://localhost:1883`) |
| `MQTT_INCOMING_TOPIC` | Topic for WA→MQTT messages |
| `MQTT_OUTGOING_TOPIC` | Topic for MQTT→WA messages |
| `PROXY_USERNAME/PASSWORD` | Proxy auth (both required) |

## Docker

- **Base:** Node.js 22 Alpine + Chromium
- **User:** Non-privileged `whatsapp:nodejs`
- **Health check:** `pgrep node.*main.js` every 30s
- **Volumes:** `.wwebjs_auth` (sessions), `.wwebjs_cache` (web cache)
- **Requires:** `shm_size: 2gb` and `seccomp:unconfined` for Chromium stability

## Code Style

- ESLint: 4-space indent, single quotes, semicolons required
- ES6+, Node.js ≥18
- `.eslintrc.json` for full rules

## Known Issues (upstream)

- **Detached Frame after ~1hr** ([#5728](https://github.com/pedroslopez/whatsapp-web.js/issues/5728)) — wrap Puppeteer calls in try/catch
- **inject() fails after sleep/resume** ([#127082](https://github.com/pedroslopez/whatsapp-web.js/issues/127082)) — context destroyed on page navigation
- **QR stale listener disconnect** ([#127089](https://github.com/pedroslopez/whatsapp-web.js/issues/127089)) — scan succeeds but client disconnects