.PHONY: help \
        frontend-get frontend-run frontend-build frontend-test \
        backend-install backend-dev backend-deploy backend-logs \
        slidev-install slidev-dev slidev-build \
        install dev

# ── Default ───────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "ssyok Finance – available targets"
	@echo ""
	@echo "  Frontend (Flutter)"
	@echo "    make frontend-get      flutter pub get"
	@echo "    make frontend-run      flutter run"
	@echo "    make frontend-build    flutter build apk"
	@echo "    make frontend-test     flutter test"
	@echo ""
	@echo "  Backend (Firebase Functions)"
	@echo "    make backend-install   npm install"
	@echo "    make backend-dev       firebase emulators:start --only functions"
	@echo "    make backend-deploy    build + firebase deploy --only functions"
	@echo "    make backend-logs      firebase functions:log"
	@echo ""
	@echo "  Pitch Deck (Slidev)"
	@echo "    make slidev-install    npm install"
	@echo "    make slidev-dev        slidev dev  (localhost:3030)"
	@echo "    make slidev-build      slidev build"
	@echo ""
	@echo "  Shortcuts"
	@echo "    make install           install all dependencies"
	@echo "    make dev               run frontend + backend emulator in parallel"
	@echo ""

# ── Frontend ──────────────────────────────────────────────────────────────────
frontend-get:
	cd frontend && flutter pub get

frontend-run:
	cd frontend && flutter run

frontend-build:
	cd frontend && flutter build apk

frontend-test:
	cd frontend && flutter test

# ── Backend ───────────────────────────────────────────────────────────────────
backend-install:
	cd backend && npm install

backend-dev:
	cd backend && npm run dev

backend-deploy:
	cd backend && npm run deploy

backend-logs:
	cd backend && npm run logs

# ── Pitch Deck ────────────────────────────────────────────────────────────────
slidev-install:
	cd slidev-pitch-deck && npm install

slidev-dev:
	cd slidev-pitch-deck && npm run dev

slidev-build:
	cd slidev-pitch-deck && npm run build

# ── Shortcuts ─────────────────────────────────────────────────────────────────
install: frontend-get backend-install slidev-install

dev:
	@echo "Starting backend emulator and Flutter in parallel..."
	@cd backend && npm run dev & cd frontend && flutter run
