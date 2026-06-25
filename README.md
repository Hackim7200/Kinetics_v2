# Kinetics

A fitness tracking app for building routines, logging workouts, and tracking progress over time. Currently a local-first mobile app with optional sign-in planned for future sync.

## Project structure

| Directory | Description |
|-----------|-------------|
| `mobile_frontend/` | Flutter app (iOS & Android) |
| `terraform/` | Infrastructure as code (planned) |

## Features

- **Routines** — Create routines and add strength or timer-based exercises
- **Workout logging** — Log sets during strength and timer sessions
- **Analytics** — Progress graphs, history tables, and training load metrics
- **Circuits** — Build and run timed circuit workouts
- **Local storage** — All data stored on-device with SQLite (Drift)

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.10)
- Xcode (iOS) or Android Studio (Android)

### Run the app

```bash
cd mobile_frontend
flutter pub get
dart run build_runner build
flutter run
```

## Tech stack

- **Flutter** — UI framework
- **Riverpod** — State management
- **Drift** — Local SQLite database
- **go_router** — Navigation

## License

Private — not published.
