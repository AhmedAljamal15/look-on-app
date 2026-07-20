# LookOn

**AI-powered virtual try-on mobile app.** Snap a photo of any garment in a store, and instantly see how it looks on you — no fitting room required.

<p align="center">
  <img src="screenshots/01_splash.jpg" width="200"/>
  <img src="screenshots/06_home_en.jpg" width="200"/>
  <img src="screenshots/08_capture_garment.jpg" width="200"/>
</p>

---

## What it does

1. User takes a one-time profile photo.
2. User photographs any garment in-store (top, bottom, or full-body piece).
3. AI generates a realistic composite showing the user wearing that exact garment.
4. Result is saved to history and can be favorited or shared.

---

## Features

- **AI Virtual Try-On** — powered by FASHN.ai (via fal.ai), supports tops, bottoms, and full-body garments (dresses, jumpsuits)
- **System-language auto-detection** — app opens in Arabic if the device is set to Arabic, English otherwise; user can override manually at any time
- **Full Arabic (MSA) & English support** — complete RTL/LTR layout handling across every screen
- **One-time onboarding** — language, gender, and preferred garment type are set once and reused across the app to improve AI accuracy
- **Favorites & history** — every try-on is saved; users can favorite and revisit past results
- **Body measurements (optional)** — height, weight, chest, waist, shoulder width, and preferred size for more accurate AI fitting
- **Daily usage limits** — cost-conscious rate limiting on AI generations per user per day
- **Offline detection** — real-time banner shown across the app when the connection drops
- **Custom design system** — Coffee Cream visual identity with animated gradients, shimmer effects, and micro-interactions throughout
- **Consent-first onboarding** — explicit terms & privacy acceptance flow before any photo is stored

---

## Tech Stack


|
 Layer 
|
 Technology 
|
|
---
|
---
|
|
 Framework 
|
 Flutter (Dart) 
|
|
 State Management 
|
 Riverpod 
|
|
 Backend / Auth 
|
 Firebase (Anonymous Auth, Firestore) 
|
|
 Image Storage 
|
 Supabase Storage 
|
|
 AI Provider 
|
 FASHN.ai (via fal.ai) 
|
|
 Routing 
|
 go_router 
|
|
 Localization 
|
 Custom i18n system (Arabic/English) 
|
|
 CI/CD 
|
 GitHub Actions (automated analysis, testing, APK builds) 
|

---

## Architecture

Feature-first Clean Architecture — each feature is self-contained with clear separation of concerns:

lib/
├── core/ # Shared infrastructure
│ ├── constants/
│ ├── errors/ # Failure (UI-facing) + Exception (data-layer) types
│ ├── localization/ # i18n strings and locale controller
│ ├── providers/ # App-wide DI (auth, storage, AI services)
│ ├── router/ # go_router config + auth-aware redirects
│ ├── theme/ # Colors, typography, spacing tokens
│ └── widgets/ # Shared UI (buttons, banners, animations)
│
├── features/
│ ├── onboarding/ # Welcome flow, consent, language detection
│ ├── home/ # Main dashboard
│ ├── profile_photo/ # One-time profile photo capture
│ ├── try_on/ # Garment capture + AI generation flow
│ ├── result/ # AI result display, sharing, favoriting
│ ├── history/ # Past attempts, favorites filter
│ ├── measurements/ # Optional body measurements
│ ├── user_profile/ # Account settings, preferences
│ └── preferences/ # Gender & garment-type preferences
│
└── main.dart


Each feature follows:
- `presentation/` — screens (UI only) + widgets
- `application/` — Riverpod providers/notifiers (business logic)
- `data/` — repositories, data sources
- `domain/` — models, entities, enums

---

## Screenshots

### Onboarding & Setup

<p align="center">
  <img src="screenshots/02_onboarding_ar.jpg" width="200"/>
  <img src="screenshots/04_language_select.jpg" width="200"/>
  <img src="screenshots/05_setup_preferences.jpg" width="200"/>
</p>

### Home (Arabic & English)

<p align="center">
  <img src="screenshots/07_home_ar.jpg" width="200"/>
  <img src="screenshots/06_home_en.jpg" width="200"/>
</p>

### Try-On Flow

<p align="center">
  <img src="screenshots/08_capture_garment.jpg" width="200"/>
  <img src="screenshots/09_generating.jpg" width="200"/>
</p>

### History & Measurements

<p align="center">
  <img src="screenshots/10_history_empty.jpg" width="200"/>
  <img src="screenshots/11_measurements.jpg" width="200"/>
</p>

### Profile (Arabic & English)

<p align="center">
  <img src="screenshots/12_profile_ar.jpg" width="200"/>
  <img src="screenshots/13_profile_en.jpg" width="200"/>
</p>

---

## CI/CD

Every push to `main` triggers a GitHub Actions pipeline that:
1. Installs dependencies and analyzes the codebase (`flutter analyze`)
2. Runs the test suite
3. Builds a release APK and uploads it as a workflow artifact

---

## Author

**Ahmed Aljamal** — [github.com/AhmedAljamal15](https://github.com/AhmedAljamal15)
