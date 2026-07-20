<div align="center">

# LookOn

### AI-Powered Virtual Try-On

Take a photo of any garment and instantly visualize how it looks on you — without entering a fitting room.

<br>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square\&logo=flutter\&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square\&logo=dart\&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=flat-square\&logo=firebase\&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-6B57FF?style=flat-square)](https://riverpod.dev)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=flat-square\&logo=githubactions\&logoColor=white)](https://github.com/features/actions)

<br>

<p>
  <img src="screenshots/01_splash.jpeg" width="210" alt="LookOn splash screen"/>
  &nbsp;
  <img src="screenshots/06_home_en.jpeg" width="210" alt="LookOn English home screen"/>
  &nbsp;
  <img src="screenshots/08_capture_garment.jpeg" width="210" alt="LookOn garment capture screen"/>
</p>

<br>

**Capture. Generate. Try it on virtually.**

</div>

---

## What It Does

LookOn transforms the in-store clothing experience into a fast virtual try-on workflow.

1. The user captures a one-time profile photo.
2. The user photographs a garment, including tops, bottoms, dresses, or full-body pieces.
3. AI generates a realistic result showing the user wearing the selected garment.
4. The generated image is saved and can be revisited, favorited, or shared.

---

## Features

| Feature                             | Description                                                                                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------------- |
| **AI Virtual Try-On**               | Generates realistic clothing previews using FASHN.ai through fal.ai.                              |
| **Multiple Garment Categories**     | Supports tops, bottoms, dresses, jumpsuits, and other full-body garments.                         |
| **Automatic Language Detection**    | Opens in Arabic when the device language is Arabic and in English otherwise.                      |
| **Arabic and English Localization** | Complete RTL and LTR support across the entire application.                                       |
| **One-Time Onboarding**             | Saves language, gender, and garment preferences for future sessions.                              |
| **Favorites and History**           | Stores generated results and allows users to mark preferred items as favorites.                   |
| **Optional Measurements**           | Supports height, weight, chest, waist, shoulder width, and preferred clothing size.               |
| **Daily Usage Limits**              | Controls AI generation usage per user to manage service costs.                                    |
| **Offline Detection**               | Displays a global real-time banner whenever the internet connection is lost.                      |
| **Custom Design System**            | Uses a Coffee Cream identity with gradients, shimmer effects, animations, and micro-interactions. |
| **Consent-First Experience**        | Requires explicit terms and privacy acceptance before storing user photos.                        |

---

## Tech Stack

| Layer                | Technology                            |
| -------------------- | ------------------------------------- |
| **Framework**        | Flutter and Dart                      |
| **State Management** | Riverpod                              |
| **Backend**          | Firebase                              |
| **Authentication**   | Firebase Anonymous Authentication     |
| **Database**         | Cloud Firestore                       |
| **Image Storage**    | Supabase Storage                      |
| **AI Provider**      | FASHN.ai through fal.ai               |
| **Routing**          | go_router                             |
| **Localization**     | Custom Arabic and English i18n system |
| **CI/CD**            | GitHub Actions                        |

---

## Architecture

LookOn follows a **feature-first Clean Architecture** approach.

Each feature is isolated and organized into presentation, application, data, and domain layers. Shared infrastructure is placed inside the `core` directory.

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── localization/
│   ├── providers/
│   ├── router/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
├── features/
│   ├── onboarding/
│   ├── home/
│   ├── profile_photo/
│   ├── try_on/
│   ├── result/
│   ├── history/
│   ├── measurements/
│   ├── user_profile/
│   └── preferences/
│
└── main.dart
```

### Feature Structure

```text
feature/
├── presentation/
│   ├── screens/
│   └── widgets/
│
├── application/
│   ├── providers/
│   └── notifiers/
│
├── data/
│   ├── repositories/
│   └── data_sources/
│
└── domain/
    ├── models/
    ├── entities/
    └── enums/
```

| Layer           | Responsibility                                       |
| --------------- | ---------------------------------------------------- |
| `presentation/` | Screens, reusable widgets, and user interface logic  |
| `application/`  | Riverpod providers, notifiers, and business logic    |
| `data/`         | Repository implementations and external data sources |
| `domain/`       | Models, entities, enums, and repository contracts    |

---

## Screenshots

### Onboarding & Setup

<p align="center">
  <img src="screenshots/02_onboarding_ar.jpeg" width="210" alt="Arabic onboarding screen"/>
  &nbsp;
  <img src="screenshots/04_language_select.jpeg" width="210" alt="Language selection screen"/>
  &nbsp;
  <img src="screenshots/05_setup_preferences.jpeg" width="210" alt="Preferences setup screen"/>
</p>

### Home — Arabic & English

<p align="center">
  <img src="screenshots/07_home_ar.jpeg" width="210" alt="Arabic home screen"/>
  &nbsp;
  <img src="screenshots/06_home_en.jpeg" width="210" alt="English home screen"/>
</p>

### Try-On Flow

<p align="center">
  <img src="screenshots/08_capture_garment.jpeg" width="210" alt="Garment capture screen"/>
  &nbsp;
  <img src="screenshots/09_generating.jpeg" width="210" alt="AI generation screen"/>
</p>

### History & Measurements

<p align="center">
  <img src="screenshots/10_history_empty.jpeg" width="210" alt="Empty history screen"/>
  &nbsp;
  <img src="screenshots/11_measurements.jpeg" width="210" alt="Body measurements screen"/>
</p>

### Profile — Arabic & English

<p align="center">
  <img src="screenshots/12_profile_ar.jpeg" width="210" alt="Arabic profile screen"/>
  &nbsp;
  <img src="screenshots/13_profile_en.jpeg" width="210" alt="English profile screen"/>
</p>

---

## CI/CD

Every push or pull request targeting the `main` branch triggers the GitHub Actions workflow.

```text
Push or Pull Request
          │
          ▼
Install Dependencies
          │
          ▼
Verify Formatting
          │
          ▼
Analyze Source Code
          │
          ▼
Run Automated Tests
          │
          ▼
Build Release APK
          │
          ▼
Upload APK Artifact
```

The generated Android APK can be downloaded from the workflow run under the **Artifacts** section.

---

## Author

<div align="center">

### Ahmed Gad Aljamal

Flutter Developer

[![GitHub Profile](https://img.shields.io/badge/GitHub-Profile-181717?style=for-the-badge\&logo=github\&logoColor=white)](https://github.com/AhmedAljamal15)
[![LookOn Repository](https://img.shields.io/badge/Project-LookOn-6F4E37?style=for-the-badge\&logo=github\&logoColor=white)](https://github.com/AhmedAljamal15/look-on-app)

<br>

**GitHub Profile:**
https://github.com/AhmedAljamal15

**Project Repository:**
https://github.com/AhmedAljamal15/look-on-app

</div>

</div>
