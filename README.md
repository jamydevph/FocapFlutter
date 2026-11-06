# Focap

Block the noise, keep what you need.

Focap is an Android focus timer that blocks the apps you pick for as long as you choose, while everything else keeps working. You can always end a session early: it's a self-control tool, not a parental control.

> Work in progress. Sections below are filled in as the features land.

## Features

- Pick the apps that distract you; everything else stays open
- Focus timer with presets and a custom length
- Blocking that keeps working with the app closed, offline or after a reboot
- Session history, backed up to your account

## Screenshots

_Coming soon._

## Tech stack

Flutter · Dart · Riverpod · go_router · Firebase Auth · Cloud Firestore · sqflite · Kotlin (AccessibilityService, platform channels)

## Architecture

MVVM: View → ViewModel → Repository → Service. Blocking runs natively in Kotlin, so it doesn't depend on Flutter being alive.

```
focapflutter/lib/
├── core/      router, theme, utils
├── domain/    session rules (pure Dart)
├── data/      models, services, repositories
└── ui/        one folder per screen
```

## Getting started

```bash
cd focapflutter
flutter pub get
flutter run
```

Requires Flutter 3.47 or later and Android 8.0 (API 26) or later.

## Privacy

Focap never uploads which apps are installed or blocked. A full privacy policy will be linked here.
