# Firebase Setup Guide for Flutter Projects

A complete reference for setting up Firebase from scratch using the CLI.
Written based on the actual setup of **ssyok Finance** (KitaHack 2026).

---

## Prerequisites

### 1. Check what's installed

```bash
# Check Firebase CLI
firebase --version
# Expected: 15.x.x or newer

# Check FlutterFire CLI (separate from Firebase CLI)
flutterfire --version
# If not found, install it:
dart pub global activate flutterfire_cli

# Add pub-cache bin to PATH if not already (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Check gcloud CLI (optional but useful)
gcloud --version

# Check Flutter
flutter --version
```

### 2. Install Firebase CLI (if missing)

```bash
# Option A: via npm
npm install -g firebase-tools

# Option B: via standalone script (Linux/macOS)
curl -sL https://firebase.tools | bash

# Verify
firebase --version
```

---

## Step 1 — Login to Firebase

```bash
# Login via browser
firebase login

# Verify you're logged in and see your projects
firebase projects:list
```

**Expected output:**
```
┌─────────────────────┬─────────────────────┬────────────────┐
│ Project Display Name│ Project ID          │ Project Number │
├─────────────────────┼─────────────────────┼────────────────┤
│ sandbox             │ smart-bloom-350004  │ 908117969556   │
└─────────────────────┴─────────────────────┴────────────────┘
```

---

## Step 2 — Create a Firebase Project (or choose existing)

### Option A: Create new project via CLI

```bash
firebase projects:create YOUR-PROJECT-ID --display-name "Your Project Name"

# Example:
firebase projects:create open-ssyok-finance --display-name "Open ssyok Finance"
```

> **Note:** CLI project creation can fail if billing is not set up or quota limits
> are hit. If it fails, use Option B.

### Option B: Create via Firebase Console (more reliable)

1. Go to https://console.firebase.google.com
2. Click **"Add project"**
3. Enter project ID (e.g. `open-ssyok-finance`)
4. Set display name
5. Choose whether to enable Google Analytics
6. Click **"Create project"**

### Option C: Use an existing project (e.g. sandbox)

```bash
# Just note the project ID from projects:list output
# e.g. smart-bloom-350004
# Use this ID in all subsequent commands
```

> **Why use sandbox for a hackathon?**
> Firebase isolates data by user UID. As long as your Firestore structure is
> `users/{uid}/...`, different apps/users in the same project will never see
> each other's data. Safe for prototyping.

---

## Step 3 — Enable Required Google Cloud APIs

Some APIs are not enabled by default. Enable them with gcloud:

```bash
# Enable Firestore
gcloud services enable firestore.googleapis.com --project=YOUR-PROJECT-ID

# Enable Firebase Auth (Identity Toolkit)
gcloud services enable identitytoolkit.googleapis.com --project=YOUR-PROJECT-ID

# Enable Cloud Functions (if using backend)
gcloud services enable cloudfunctions.googleapis.com --project=YOUR-PROJECT-ID

# Check which services are enabled
gcloud services list --project=YOUR-PROJECT-ID --enabled
```

---

## Step 4 — Create Firestore Database

```bash
# Create the default database
# Location options: nam5 (US), eur3 (Europe), asia-southeast1 (Singapore - best for Malaysia)
firebase --project=YOUR-PROJECT-ID firestore:databases:create "(default)" --location=asia-southeast1

# Verify it was created
firebase --project=YOUR-PROJECT-ID firestore:databases:list
```

**Location reference:**
| Region | Location ID | Best for |
|--------|-------------|----------|
| Singapore | `asia-southeast1` | Malaysia, SEA |
| Taiwan | `asia-east1` | East Asia |
| US (multi) | `nam5` | US users |
| Europe (multi) | `eur3` | EU users |

---

## Step 5 — Set Up Firestore Security Rules

### Create the rules file

```bash
# In your project root (not frontend/)
touch firestore.rules
touch firestore.indexes.json
touch firebase.json
```

**`firestore.rules`** — user-scoped security:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // All sub-collections (assets, debts, goals, etc.)
      match /{collection}/{docId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

**`firestore.indexes.json`** — start empty:

```json
{
  "indexes": [],
  "fieldOverrides": []
}
```

**`firebase.json`** — tells Firebase CLI what to deploy:

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  }
}
```

### Deploy the rules

```bash
# From project root (where firebase.json is)
firebase --project=YOUR-PROJECT-ID deploy --only firestore:rules

# Verify deployment
firebase --project=YOUR-PROJECT-ID firestore:rules:get
```

---

## Step 6 — Configure FlutterFire (generates firebase_options.dart)

This is the key step that links your Flutter app to Firebase.
Run it from inside your **Flutter project directory**.

```bash
cd frontend/   # or wherever your Flutter project is

# Configure all platforms at once
$HOME/.pub-cache/bin/flutterfire configure \
  --project=YOUR-PROJECT-ID \
  --platforms=android,ios,web \
  --yes
```

**What this does:**
1. Detects your Flutter app's bundle ID from `pubspec.yaml` / build files
2. Registers Android, iOS, and web apps on your Firebase project
3. Downloads config files for each platform
4. Generates `lib/firebase_options.dart` with real API keys

**Expected output:**
```
i Registered a new Firebase android app on Firebase project YOUR-PROJECT-ID.
i Registered a new Firebase ios app on Firebase project YOUR-PROJECT-ID.
i Firebase web app ssyok_finance (web) registered.

Firebase configuration file lib/firebase_options.dart generated successfully
```

**Files generated/modified:**
- `lib/firebase_options.dart` — main config used in `main.dart`
- `android/app/google-services.json` — Android config
- `ios/Runner/GoogleService-Info.plist` — iOS config

### Re-running flutterfire configure

If you need to re-run (e.g. switching projects):

```bash
# It will detect existing apps and ask if you want to reuse or create new
$HOME/.pub-cache/bin/flutterfire configure --project=NEW-PROJECT-ID
```

---

## Step 7 — Enable Firebase Authentication

### Enable Google Sign-In (manual — requires Console UI)

Google Sign-In **cannot be fully enabled via CLI** because it needs an OAuth
consent screen configuration. This is a one-time 2-minute step:

1. Open: `https://console.firebase.google.com/project/YOUR-PROJECT-ID/authentication/providers`
2. Click **"Get started"** (first time only)
3. Click **"Google"** in the provider list
4. Toggle **"Enable"** to ON
5. Set **"Project support email"** to your email
6. Click **"Save"**

### Get the Web OAuth Client ID (required for Flutter web)

After enabling Google Sign-In, Firebase auto-creates an OAuth 2.0 Web Client.
You need this Client ID for the Flutter web build:

1. Go to: `https://console.cloud.google.com/apis/credentials?project=YOUR-PROJECT-ID`
2. Under **"OAuth 2.0 Client IDs"**, find **"Web client (auto created by Google Service)"**
3. Copy the **Client ID** (format: `NUMBERS-HASH.apps.googleusercontent.com`)

### Add Web Client ID to Flutter web (`web/index.html`)

The `google_sign_in_web` package requires the Client ID as a meta tag.
**Without this, you get: `appClientId != null, clientID not set`**

Add to `web/index.html` inside `<head>`, before `</head>`:

```html
<!-- Google Sign-In Web Client ID (required for google_sign_in_web) -->
<meta name="google-signin-client_id" content="YOUR-CLIENT-ID.apps.googleusercontent.com">
```

Example:
```html
<meta name="google-signin-client_id" content="908117969556-ifarvkn4r5jahd0o09sel425v7u64bkj.apps.googleusercontent.com">
```

> **Note:** This Client ID is safe to include in the HTML — it is public-facing by design.
> It is NOT the same as your Gemini/Firebase API key (never expose those).

### Enable Email/Password (optional, via CLI)

```bash
# Check auth config
ACCESS_TOKEN=$(gcloud auth print-access-token --project=YOUR-PROJECT-ID)

curl -s \
  "https://identitytoolkit.googleapis.com/v2/projects/YOUR-PROJECT-ID/config" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "X-Goog-User-Project: YOUR-PROJECT-ID"
```

### Enable People API (required for Google Sign-In profile fetch)

Google Sign-In fetches the user's name/email/photo via the People API.
Without it you get: `People API has not been used in project...`

```bash
gcloud services enable people.googleapis.com --project=YOUR-PROJECT-ID
```

### Verify Auth is working

```bash
# Try exporting users (should return empty list, not error)
firebase --project=YOUR-PROJECT-ID auth:export /tmp/auth-check.json
# Expected: "Exporting accounts to /tmp/auth-check.json" + success
```

---

## Step 8 — Integrate Firebase in Flutter

### Install dependencies

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  google_sign_in: ^6.2.1
```

```bash
flutter pub get
```

### Initialize in main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

> **Tip:** Wrap in try/catch during development so the app still runs
> if Firebase isn't configured yet:
>
> ```dart
> try {
>   await Firebase.initializeApp(
>     options: DefaultFirebaseOptions.currentPlatform,
>   );
> } catch (e) {
>   debugPrint('Firebase init failed: $e');
> }
> ```

### Enable Firestore offline persistence (web)

```dart
// In main.dart, after Firebase.initializeApp()
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

---

## Step 9 — Deploy Everything

```bash
# Deploy rules only
firebase --project=YOUR-PROJECT-ID deploy --only firestore:rules

# Deploy rules + indexes
firebase --project=YOUR-PROJECT-ID deploy --only firestore

# Deploy Cloud Functions (if you have them)
firebase --project=YOUR-PROJECT-ID deploy --only functions

# Deploy everything
firebase --project=YOUR-PROJECT-ID deploy
```

---

## Step 10 — Run and Test

```bash
cd frontend/

# Web (easiest for testing Firebase Auth)
flutter run -d chrome

# Android (requires connected device or emulator)
flutter run -d android

# iOS (requires macOS + Xcode)
flutter run -d ios

# List available devices
flutter devices
```

---

## Useful Firebase CLI Commands

### Project management

```bash
# List all projects
firebase projects:list

# Switch active project
firebase use YOUR-PROJECT-ID

# See currently active project
firebase use
```

### Firestore

```bash
# List databases
firebase --project=YOUR-PROJECT-ID firestore:databases:list

# View rules
firebase --project=YOUR-PROJECT-ID firestore:rules:get

# Deploy rules
firebase --project=YOUR-PROJECT-ID deploy --only firestore:rules

# Export data (backup)
firebase --project=YOUR-PROJECT-ID firestore:export gs://YOUR-BUCKET/backup

# Delete a collection (careful!)
firebase --project=YOUR-PROJECT-ID firestore:delete /users --recursive
```

### Authentication

```bash
# Export all users
firebase --project=YOUR-PROJECT-ID auth:export users.json

# Import users
firebase --project=YOUR-PROJECT-ID auth:import users.json

# Delete a specific user
firebase --project=YOUR-PROJECT-ID auth:delete USER_UID
```

### Functions

```bash
# List deployed functions
firebase --project=YOUR-PROJECT-ID functions:list

# View function logs
firebase --project=YOUR-PROJECT-ID functions:log

# Delete a function
firebase --project=YOUR-PROJECT-ID functions:delete functionName
```

---

## Useful gcloud Commands

```bash
# Login
gcloud auth login

# Set default project
gcloud config set project YOUR-PROJECT-ID

# List enabled APIs
gcloud services list --enabled --project=YOUR-PROJECT-ID

# Enable an API
gcloud services enable SERVICE.googleapis.com --project=YOUR-PROJECT-ID

# Get access token (useful for REST API calls)
gcloud auth print-access-token

# List service accounts
gcloud iam service-accounts list --project=YOUR-PROJECT-ID
```

---

## Troubleshooting

### "Firebase app not registered"
```bash
# Re-run flutterfire configure to register missing platforms
cd frontend/
$HOME/.pub-cache/bin/flutterfire configure --project=YOUR-PROJECT-ID
```

### "Firestore API not enabled"
```bash
gcloud services enable firestore.googleapis.com --project=YOUR-PROJECT-ID
```

### "CONFIGURATION_NOT_FOUND" on Auth export
Firebase Auth has not been initialized. Go to the Firebase Console and enable
at least one sign-in method (even just Email/Password) to initialize Auth.

### "FlutterFire CLI not found"
```bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### "firebase_options.dart has TODO placeholders"
You skipped `flutterfire configure`. Run it from your Flutter project directory:
```bash
cd frontend/
$HOME/.pub-cache/bin/flutterfire configure --project=YOUR-PROJECT-ID --platforms=android,ios,web --yes
```

### google-services.json missing (Android build fails)
FlutterFire generates this automatically. If missing:
```bash
cd frontend/
$HOME/.pub-cache/bin/flutterfire configure --project=YOUR-PROJECT-ID --platforms=android
```

### Firestore rules blocking reads/writes
Check your rules. For development, temporarily open rules (never in production):
```javascript
// DEVELOPMENT ONLY — wide open
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
Then lock them down properly before going live.

---

## Project Structure After Setup

```
my-project/                    ← repo root
├── firebase.json              ← Firebase CLI config
├── firestore.rules            ← Firestore security rules
├── firestore.indexes.json     ← Firestore composite indexes
│
└── frontend/                  ← Flutter app
    ├── lib/
    │   └── firebase_options.dart   ← Generated by flutterfire configure
    ├── android/
    │   └── app/
    │       └── google-services.json   ← Generated by flutterfire configure
    └── ios/
        └── Runner/
            └── GoogleService-Info.plist  ← Generated by flutterfire configure
```

---

## Summary Checklist

```
[ ] firebase --version                          # CLI installed
[ ] flutterfire --version                       # FlutterFire CLI installed
[ ] firebase login                              # Logged in
[ ] firebase projects:list                      # Can see your projects
[ ] gcloud services enable firestore...         # Firestore API enabled
[ ] firebase firestore:databases:create         # Database created
[ ] firestore.rules written                     # Security rules defined
[ ] firebase deploy --only firestore:rules      # Rules deployed
[ ] cd frontend/ && flutterfire configure       # firebase_options.dart generated
[ ] Enable Google Sign-In in Firebase Console   # Manual step (UI only)
[ ] Get Web OAuth Client ID from Cloud Console  # credentials page
[ ] Add client_id meta tag to web/index.html    # fixes "clientID not set" error
[ ] CHROME_EXECUTABLE=/usr/bin/chromium-browser flutter run -d chrome  # if using Chromium
[ ] flutter run -d chrome                       # App runs with Firebase
```

---

*Created during ssyok Finance (KitaHack 2026) setup — February 2026*
