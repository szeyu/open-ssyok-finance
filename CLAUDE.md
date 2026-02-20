# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ssyok Finance** is a financial companion app for young Malaysians, entered into KitaHack 2026. The project consists of three main components:

1. **Frontend** (`frontend/`) - Flutter mobile app (migration target from React Native)
2. **Backend** (`backend/`) - Node.js + Firebase Cloud Functions
3. **Pitch Deck** (`slidev-pitch-deck/`) - Slidev presentation for Demo Day

A legacy React Native app exists in `ssyok-Finance/` (archived reference only, do not modify).

## Architecture

The tech stack is optimized for KitaHack 2026's requirement to use Google technologies:

```
Flutter App → Firebase Auth → Firestore
           ↓
    Cloud Functions → Gemini 2.5 Flash
```

**Key Technologies:**
- **Frontend**: Flutter 3+ with Riverpod/Bloc state management, GoRouter navigation
- **Backend**: Node.js, Firebase Cloud Functions, Firestore
- **AI**: Google Gemini 2.5 Flash (mandatory - do NOT use OpenAI, Claude, or other non-Google AI)
- **Auth**: Firebase Auth with Google Sign-In

## Development Commands

A root-level `Makefile` exists — prefer `make` targets over running commands manually.

### Common Make Targets
```bash
make help              # List all available targets
make install           # Install all dependencies (flutter + npm x2)
make dev               # Run backend emulator + Flutter in parallel

make frontend-get      # flutter pub get
make frontend-run      # flutter run
make frontend-build    # flutter build apk
make frontend-test     # flutter test

make backend-install   # npm install (backend/)
make backend-dev       # firebase emulators:start --only functions
make backend-deploy    # build + firebase deploy --only functions
make backend-logs      # firebase functions:log

make slidev-dev        # slidev dev server (localhost:3030)
make slidev-build      # slidev build
```

### Raw Commands (if needed without Make)
```bash
# Frontend
cd frontend && flutter pub get
cd frontend && flutter run

# Backend
cd backend && npm install
cd backend && npm run dev

# Slidev
cd slidev-pitch-deck && npm install
cd slidev-pitch-deck && npm run dev
```

## Code Structure

### Frontend (`frontend/`)
When creating the Flutter app, follow this structure:
```
lib/
├── main.dart
├── app/              # App-level config (theme, routes)
├── features/         # Feature-based modules (onboarding, dashboard, insights)
│   └── [feature]/
│       ├── presentation/   # Screens, widgets
│       ├── domain/         # Business logic, models
│       └── data/           # Repositories, data sources
├── core/             # Shared utilities, constants
└── shared/           # Reusable UI components
```

### Backend (`backend/`)
Expected structure for Firebase Functions:
```
src/
├── index.ts          # Function exports
├── routes/           # API endpoint handlers
├── services/         # Business logic (Gemini integration)
└── middleware/       # Auth verification, validation
```

### Legacy App Reference (`ssyok-Finance/`)
The React Native app has these key folders (reference only):
- `src/components/` - Reusable UI components (Button, Card, Input, etc.)
- `src/screens/` - Main app screens
- `src/context/` - React Context providers
- `src/hooks/` - Custom React hooks
- `src/utils/` - Utility functions

Do NOT modify files in `ssyok-Finance/` - treat it as read-only reference material.

## Key Features & Context

### Gemini Finance Explainer (Primary AI Feature)
- **Location**: Server-side (Cloud Functions → Gemini API)
- **Flow**: User taps Insights → Fetch transactions → Call Gemini with prompt → Display insights card
- **Prompt Strategy**: Include user persona (Student/Saver/Spender) + transaction JSON + Malaysian context
- See: `contexts/kitahack-2026/concepts/05-feature-gemini.md`

### Authentication
- Use Firebase Auth with Google Sign-In (no custom JWT implementation needed)
- Client gets ID token → passes to Cloud Functions → verifies via Firebase Admin SDK

## Important Constraints

### KitaHack 2026 Rules (MANDATORY)
1. **MUST use Google Gemini** - No OpenAI, Anthropic Claude, or other non-Google AI models
2. **MUST use at least one Google technology** - We use Firebase, Flutter, and Gemini
3. **Scoring optimized for**: Impact (60%), Innovation (25%), Technical (15%)

### Development Practices
- Use Flutter best practices: feature-based architecture, immutable state, composition over inheritance
- Prefer Riverpod or Bloc for state management (not Provider)
- Follow Material Design 3 guidelines
- All AI prompts must include Malaysian context (e.g., "Mamak", "RM" currency, local spending patterns)

## Documentation Structure

The `contexts/` folder contains comprehensive documentation:

### Competition Context (`contexts/kitahack-2026/`)
- `concepts/` - Timeline, tech requirements, judging rubric, team status
- `techniques/` - Backend architecture, scoring strategy, submission workflow
- `pitch-deck/` - Problem validation, market analysis, SWOT, monetization
- `judging-criteria-completeness/` - Preliminary and final round checklists

### Legacy App Docs (`contexts/ssyok-finance/`)
Reference material reverse-engineered from the React Native app.

All markdown files use:
- Mermaid diagrams for architecture and flows
- `[[wikilinks]]` for internal navigation (Obsidian-compatible)
- Tables for comparison and status tracking
- "Last Updated" timestamps at the bottom

## Skills Available

Use these specialized skills for specific tasks:
- `flutter-expert` - Flutter development patterns and architecture
- `flutter-adaptive-ui` - Responsive layouts for mobile/tablet/desktop
- `flutter-animations` - Motion and visual effects
- `slidev` - Create and present web-based slides
- `baoyu-slide-deck` - Generate slide deck images
- `study-notes-creator` - Organize documentation with diagrams

## Firebase Setup

### Active Firebase Project
- **Project name**: sandbox (display name) / **smart-bloom-350004** (project ID)
- **Project number**: 908117969556
- **Firestore bucket**: `smart-bloom-350004.firebasestorage.app`
- Firebase config already initialised — `frontend/lib/firebase_options.dart` and `frontend/android/app/google-services.json` are present

### Notes
1. Frontend: FlutterFire already configured (`flutterfire configure` was run)
2. Backend: Firebase Functions with TypeScript
3. Database: Firestore in native mode (not Datastore)
4. Regions: Use `asia-southeast1` (Singapore) for optimal latency in Malaysia
5. Deploy alias: run `firebase use smart-bloom-350004` if the CLI asks for a project

## Testing Strategy

For the hackathon, prioritize:
1. **User flow testing** - Onboarding → Dashboard → AI insights
2. **Gemini integration tests** - Verify prompt structure and response parsing
3. **Firebase Auth testing** - Ensure token validation works

## Common Pitfalls

1. **Do NOT** use non-Google AI models (even for testing) - this violates competition rules
2. **Do NOT** expose Gemini API keys in Flutter client - always proxy through Cloud Functions
3. **Do NOT** over-engineer - focus on the AI feature and core user flow for the demo
4. **Do NOT** modify `ssyok-Finance/` folder - it's archived reference material
5. **Do NOT** forget to include Malaysian context in all AI prompts and UI copy

## Submission Requirements

- Submission deadline: **February 28, 2026**
- Demo Day: **March 29, 2026**
- Required deliverables: Working prototype + pitch deck + demo video

## Additional Resources

- Backend architecture details: `contexts/kitahack-2026/techniques/03-backend-architecture.md`
- Gemini feature spec: `contexts/kitahack-2026/concepts/05-feature-gemini.md`
- Judging criteria: `contexts/kitahack-2026/concepts/03-judging-rubric.md`
- Pitch deck outline: `contexts/kitahack-2026/pitch-deck/08-slidev-outline.md`
