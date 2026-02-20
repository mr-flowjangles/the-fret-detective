.PHONY: up down build logs help

up:
	@echo "Starting services..."
	@docker compose up --build -d
	@echo ""
	@echo "Site running at http://localhost:3000"
	@echo ""
	@echo "View logs: make logs"
	@echo "Stop services: make down"

down:
	@echo "Stopping services..."
	@docker compose down
	@echo "Services stopped"

build:
	@echo "Building images..."
	@docker compose build --no-cache
	@echo "Build complete"

logs:
	@docker compose logs -f

help:
	@echo "Available commands:"
	@echo "  make up     - Start the dev server"
	@echo "  make down   - Stop the dev server"
	@echo "  make build  - Rebuild images"
	@echo "  make logs   - View logs"
	@echo "  make help   - Show this help"