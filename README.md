<p align="center">
  <img src="app/img/bot-factory.png" alt="Bot Factory Logo" width="200">
</p>

<h1 align="center">Bot Factory UI</h1>

<p align="center">
  A lightweight, customizable frontend template for building chatbot interfaces.<br>
  Fork it, configure it, and connect it to your own backend.
</p>

---

## How It Works

Bot Factory UI is the frontend component designed to work with [Bot Factory](https://github.com/mr-flowjangles/bot-factory) — the backend that handles RAG, embeddings, and chat responses.

| Repo | Purpose |
|------|---------|
| [bot-factory](https://github.com/mr-flowjangles/bot-factory) | Backend API (Python/FastAPI, vector search, Claude integration) |
| [bot-factory-ui](https://github.com/mr-flowjangles/bot-factory-ui) | Frontend template (this repo) |

You can use this UI with any backend that implements the expected API contract, but it's built to pair with Bot Factory out of the box.

---

## Quick Start

**Prerequisites:** Docker and Docker Compose

```bash
# Clone the repo
git clone https://github.com/mr-flowjangles/bot-factory-ui.git
cd bot-factory-ui

# Start the dev server
make up
```

Open [http://localhost:8080](http://localhost:8080) to see your bot.

## Commands

| Command | Description |
|---------|-------------|
| `make up` | Start the dev server |
| `make down` | Stop all services |
| `make build` | Rebuild images (no cache) |
| `make logs` | Tail container logs |

## Configuration

All customization happens in `app/index.html`. Look for the `CONFIGURABLE` comments:

**1. Bot Identity**
```html
<title>YourBot — Your Bot Description</title>
```

**2. Header**
```html
<img src="img/your-logo.png" alt="Logo" class="header-image">
<div class="header-title">YourBot</div>
<div class="header-subtitle">A short description of what your bot does</div>
```

**3. Navigation**
```html
<a href="#topic-1"><span class="nav-icon">📖</span> Topic 1</a>
```

**4. API Endpoint**
```javascript
window.BOT_CONFIG = {
    apiUrl: '/api/your_bot',
    botName: 'YourBot',
    placeholder: 'Ask a question...'
};
```

## Project Structure

```
bot-factory-ui/
├── app/                    # Frontend files
│   ├── index.html          # Main template (edit this)
│   ├── bot_styles/         # CSS
│   ├── bot_scripts/        # Chat + navigation JS
│   └── img/                # Your logo/images
├── nginx/                  # Nginx config
├── .github/workflows/      # CI/CD (Pa11y accessibility tests)
├── docker-compose.yml
└── Makefile
```

## Connecting Your Backend

The frontend expects a POST endpoint at the URL you configure in `BOT_CONFIG.apiUrl`. It sends:

```json
{ "message": "user's question" }
```

And expects:

```json
{ "response": "bot's answer" }
```

## Accessibility

This template includes Pa11y for Section 508 / WCAG compliance testing. The GitHub Actions workflow runs accessibility checks on every push.

## Forking for Your Own Bot

1. Fork this repo
2. Update `app/index.html` with your bot's branding
3. Point `apiUrl` to your backend
4. Deploy however you like (ECS, Vercel, a VPS, etc.)

---

## License & Attribution

This project is free to use, modify, and distribute. If you use Bot Factory UI in your project, please give credit by including a link back to this repo or mentioning the original author.

**Example attribution:**
> Built with [Bot Factory UI](https://github.com/mr-flowjangles/bot-factory-ui) by Rob Rose

---

<p align="center">
  <strong>Created by <a href="https://robrose.info">Rob Rose</a></strong><br>
  Software engineer, blues guitarist, and builder of chatbots.
</p>