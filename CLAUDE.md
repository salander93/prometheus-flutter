# CLAUDE.md — Prometheus Flutter App

## Project Overview

Prometheus is a gym/fitness tracking mobile app built with Flutter. It's the native frontend for the Prometheus (formerly "Palestra") Django backend API.

**Stack:** Flutter 3.41+, Dart 3.11+, Riverpod 2.x, GoRouter, Dio, Freezed, Material 3

## Architecture

Clean Architecture with 3 layers:
- **data/** — Models (Freezed), Repositories impl, Remote datasources (Dio)
- **domain/** — Abstract repository interfaces, Entities, Use cases
- **presentation/** — Screens, Widgets, Riverpod providers

## Backend

- **Local dev:** `http://localhost:8010` (Django via Docker/Podman in `salander93/palestra` repo)
- **Staging:** `https://web-staging-3a9f.up.railway.app`
- **API:** Django REST Framework + JWT auth (`/api/auth/login/`, `/api/auth/refresh/`, etc.)

Start local backend: `cd ~/PycharmProjects/personal/palestra && podman compose up -d`

## Development Commands

```bash
# Run on Chrome (dev)
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8010

# Run on Android emulator
export ANDROID_HOME=~/android-sdk
$ANDROID_HOME/emulator/emulator -avd Prometheus_Phone -gpu host &
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8010

# Build APK (needs JDK 21)
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
flutter build apk --release --dart-define=API_BASE_URL=https://web-staging-3a9f.up.railway.app

# Run tests
flutter test

# Analyze
flutter analyze

# Code generation (after changing Freezed models)
dart run build_runner build --delete-conflicting-outputs

# Publish APK to GitHub Releases
gh release create v1.0.0-beta.X build/app/outputs/flutter-apk/app-release.apk --title "Prometheus vX" --repo salander93/prometheus-flutter --prerelease
```

## Key Directories

```
lib/
├── core/
│   ├── api/           # Dio client, JWT interceptor, cached API
│   ├── auth/          # Google Sign-In service
│   ├── connectivity/  # Offline detection, sync service
│   ├── error/         # AppError sealed class, ErrorHandler
│   ├── notifications/ # Push notification service (Firebase)
│   ├── routing/       # GoRouter config with auth guards
│   ├── storage/       # Token storage, Hive cache, pending sets
│   └── theme/         # Material 3 dark theme, AppColors
├── data/
│   ├── datasources/remote/  # API calls (auth, user, workout, body check, etc.)
│   ├── models/              # Freezed DTOs with JSON serialization
│   └── repositories/        # Repository implementations
├── domain/
│   └── repositories/        # Abstract interfaces
└── presentation/
    ├── auth/           # Login, Register (4-step wizard), Password reset, Google onboarding
    ├── body_checks/    # Gallery, Detail, Wizard (stories-style), Photo editor, Compare
    ├── body_metrics/   # Charts with fl_chart
    ├── dashboard/      # Client + Trainer dashboards, Calendar, Stats
    ├── exercises/      # Library with search/filter, Detail
    ├── notifications/  # Notification list
    ├── profile/        # Profile, Edit, Settings
    ├── requests/       # Connection + Plan requests
    ├── shared/         # Nav shell, Providers, Shimmer loading, Offline banner
    ├── trainers/       # Trainer search
    └── workouts/       # Plans, Plan detail, Session selector, Live workout, History
```

## 23 Screens Implemented

Auth (5): Login, Register wizard, Forgot/Reset password, Verify email, Google onboarding
Core (4): Dashboard (client/trainer), Profile, Notifications, Requests
Workouts (7): Plans list, Plan detail, Plan editor, Session selector, Live workout, Exercise library, Exercise detail, Activity history
Body (5): Gallery, Wizard, Photo editor, Detail, Compare, Metrics
Social (2): Trainer search, Settings

## Theme

Dark theme matching original PWA:
- Primary: `#FF6B35` (orange)
- Secondary: `#00D4AA` (teal)
- Background: `#0E0E10`
- Cards: `#16161A`
- Text: `#FAFAFA` / `#A1A1AA` / `#71717A`

## Firebase

- Google Sign-In configured (com.prometheus.app)
- FCM push notifications (stub — `PushNotificationService.enabled`)
- `google-services.json` is gitignored — must be copied manually from Firebase Console
- Service account key for backend: also gitignored

## Offline Support

- Stale-while-revalidate cache (Hive) on key data
- Offline workout set logging with auto-sync on reconnect
- Offline banner shown when no connectivity

## Deployment

- **Railway service:** `prometheus-web` on `salander93/prometheus-flutter`
- **Dockerfile** in root builds Flutter web + serves with nginx
- **APK:** Built locally, published via GitHub Releases
- **Domain:** https://prometheus-web-staging.up.railway.app

## Known Issues / TODOs

- Photo editor crop alignment: math-based crop may produce slightly different results between sessions — the crop captures the crop frame area based on scale/offset
- Reference photo in editor: fetches previous body check's photo for the same position
- `flutter_secure_storage` doesn't work on some mobile browsers — fallback to in-memory storage on web
- Register screen tests have 2 pre-existing failures (role card tap obscured in test viewport)
- Google Sign-In requires SHA-1 fingerprint registered in Firebase Console
