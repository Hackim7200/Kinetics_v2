# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Kinetics is a fitness tracking app (routines, workout logging, analytics, timed circuits) built with Flutter. It's currently local-first — all data lives on-device in SQLite via Drift — with sign-in and sync planned but not yet wired up.

Repo layout:

| Directory | Description |
|-----------|-------------|
| `mobile_frontend/` | Flutter app (iOS & Android) — all application code |
| `terraform/` | Infrastructure as code (currently just a placeholder/test folder, not in active use) |

## Commands

Run from `mobile_frontend/`:

```bash
flutter pub get                     # install dependencies
dart run build_runner build         # generate Drift/Riverpod codegen (.g.dart files)
dart run build_runner watch         # regenerate codegen on file changes
flutter run                         # run the app
flutter test                        # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter analyze                     # static analysis (flutter_lints)
dart run flutter_launcher_icons     # regenerate app launcher icons
```

After changing anything annotated with `@DriftDatabase`, `@Riverpod`, or a Drift `Table`, you must rerun `build_runner build` (`-d` to delete conflicting outputs first if needed) to regenerate the matching `.g.dart` file.

## Architecture

The app is organized feature-first under `lib/feature/<feature_name>/`, each following the same four-layer structure (a lightweight Clean Architecture split):

```
feature/<name>/
  data/
    repositories/   # maps Drift rows <-> domain entities; exposes Riverpod providers
    sources/        # raw Drift queries against AppDatabase, no domain knowledge
  domain/
    entities/        # plain Dart data classes, no Drift/Flutter imports
    use_cases/       # pure functions/validators operating on entities
  presentation/
    pages/          # screens
    widgets/        # feature-scoped widgets
  state/            # Riverpod notifiers (feature UI/session state), *_notifier.dart + generated .g.dart
```

Features present: `auth` (onboarding + sign-in, local-only so far), `routine`, `routine_exercise`, `circuit`, `exercise_analytics`, `counter`.

Data flow: `presentation` reads/writes through Riverpod providers → `state` notifiers (where session state exists, e.g. active strength/timer sessions, circuit play) → `data/repositories` (domain-facing API, returns/accepts entities) → `data/sources` (raw Drift queries, returns Drift row types) → `database/database.dart` (`AppDatabase`, a single Drift database with all tables).

Cross-feature shared code lives in `lib/common/` (widgets, utils) and `lib/app/` (router, theme — app-level wiring, not a feature).

### Database (`lib/database/`)

- `database.dart` defines `AppDatabase` (`@DriftDatabase`) and the migration strategy (`schemaVersion`, `onUpgrade` steps per version bump — extend this, don't rewrite past migrations).
- `database_provider.dart` exposes `appDatabaseProvider`, a keep-alive Riverpod provider. It throws until overridden — the real `AppDatabase` instance is created in `main()` and injected via `ProviderScope(overrides: [appDatabaseProvider.overrideWithValue(db)])`.
- Tables live under `database/tables/`, grouped by domain (`workout_tables/`, `circuit_tables/`).
- `tables/sync_metadata_mixin.dart` (`SyncMetadataColumns`) adds `version`, `updatedAt`, `createdAt`, `isDeleted`, `syncStatus` to every syncable table — scaffolding for the planned backend sync, not yet consumed by a sync engine.
- `soft_delete_writer.dart` (`SoftDeleteWriter`) is the single place that performs deletes: rows are never hard-deleted, only marked `isDeleted = true` with `syncStatus = 'pending'` and `version` bumped. It also implements cascade soft-deletes (e.g. deleting a routine soft-deletes its exercises and their logs/sets in one transaction). Always route deletes through this rather than issuing raw Drift deletes.

### Navigation

`app/navigation/app_router.dart` builds a single `GoRouter`. Sign-in is optional by design: `/home` (the main `AppShell`) is reachable without authentication, since auth only matters for future sync — don't gate the main shell behind sign-in, only sync-sensitive flows/APIs.

### State management

Riverpod (v3, code-generated via `riverpod_generator`/`riverpod_annotation`). Providers are defined next to what they provide (repository providers in `data/repositories/*.dart`, feature state in `state/*_notifier.dart`) rather than centralized. Run `build_runner` after adding or changing `@riverpod`/`@Riverpod` annotations.

## Conventions (from `.cursorrules`)

These apply project-wide and are enforced by convention, not tooling:

- Prefer the smallest correct change; do not refactor or rename unrelated code while completing a task.
- No premature abstraction — only abstract when there are at least two concrete use cases.
- Keep the data/domain/presentation split intact: no Drift or Flutter imports in `domain/`, no UI logic in repositories/sources.
- Use descriptive variable names (no single-letter names outside trivial loop indices).
- Comments explain *why*, not *what*.
- Don't add dependencies without justification; prefer what's already in `pubspec.yaml`.
