<p align="center">
  <img src="app/img/bot-factory.png" alt="Bot Factory Logo" width="200">
</p>

<h1 align="center">Bot Factory UI (Fork)</h1>

<p align="center">
  A lightweight, customizable frontend template for building chatbot interfaces.<br>
  Forked and customized to connect to a compatible chat backend.
</p>

<p align="center">
  <em>
    Originally forked from
    <a href="https://github.com/mr-flowjangles/bot-factory-ui">Bot Factory UI</a>.
  </em>
</p>

---

## What This Repo Is

This repository is a fork of **Bot Factory UI**, a frontend template for building chatbot interfaces.

- **This fork:** your UI + your branding + your backend wiring
- **Upstream template:** Bot Factory UI (linked above)

If you want the “canonical” version or to compare changes, check upstream.

---

## How It Works

This UI is designed to work with a backend chat API. By default, it expects a simple JSON contract:

Sends:
```json
{ "message": "user's question" }
```

Receives:
```json
{ "response": "bot's answer" }
```

You can point it at any backend that matches that contract.

---

## Quick Start

**Prerequisites:** Docker and Docker Compose

```bash
# Clone your fork
git clone <YOUR_FORK_URL>
cd <YOUR_REPO_NAME>

# Start the dev server
make up
```

Open http://localhost:3000 to see your bot.

---

## Commands

| Command | Description |
|--------|-------------|
| `make up` | Start the dev server |
| `make down` | Stop all services |
| `make build` | Rebuild images (no cache) |
| `make logs` | Tail container logs |

---

## Configuration

All customization happens in `app/index.html`. Look for `CONFIGURABLE` comments.

### 1) Bot Identity
```html
<title>YourBot — Your Bot Description</title>
```

### 2) Header
```html
<img src="img/your-logo.png" alt="Logo" class="header-image">
<div class="header-title">YourBot</div>
<div class="header-subtitle">A short description of what your bot does</div>
```

### 3) Navigation
```html
<a href="#topic-1"><span class="nav-icon">📖</span> Topic 1</a>
```

### 4) API Endpoint
```javascript
window.BOT_CONFIG = {
  apiUrl: '/api/your_bot',
  botName: 'YourBot',
  placeholder: 'Ask a question...'
};
```

---

## Project Structure

```
bot-factory-ui/
├── app/                    # Frontend files
│   ├── index.html          # Main template (edit this)
│   ├── bot_styles/         # CSS
│   ├── bot_scripts/        # Chat + navigation JS
│   └── img/                # Your logo/images
├── nginx/                  # Nginx config
├── .github/workflows/      # CI/CD (if present)
├── docker-compose.yml
└── Makefile
```

---

## Connecting Your Backend

The frontend expects a POST endpoint at the URL you configure in `BOT_CONFIG.apiUrl`.

Request:
```json
{ "message": "user's question" }
```

Response:
```json
{ "response": "bot's answer" }
```

If your backend uses a different shape (streaming, tokens, SSE, etc.), update the JS in `app/bot_scripts/`.

---

## License & Attribution

This repo is a fork of **Bot Factory UI**. Please retain attribution to the upstream project:

- Upstream: https://github.com/mr-flowjangles/bot-factory-ui

If you publish/deploy this fork, it’s good practice to include a short credit line somewhere visible (README, About page, or footer).

---
