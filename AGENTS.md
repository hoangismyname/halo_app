# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Project Overview

**Halo** is a Flutter location-based social networking app (Zenly/Jagat-style). It enables users to share real-time location with friends on a map, chat via direct messaging, update status emojis, and manage friendships. The app is in MVP/demo phase with mock data for Chat and Friends features — Supabase Realtime sync is not yet wired up for those modules.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Analyze code for lint errors
flutter analyze

# Run tests
flutter test

# Run the app
flutter run

# Build for release
flutter build apk --release

# Build for debug
flutter build apk --debug
```

## Code Generation

This project uses code generation for Riverpod, Freezed, and JSON serialization. After modifying any `.dart` file with `@riverpod`, `freezed`, or `json_serializable` annotations, you must regenerate:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files: `*.g.dart` (Riverpod), `*.freezed.dart` (Freezed), `*.g.dart` (JSON).

## Architecture

### Tech Stack
- **Flutter** with Dart SDK ^3.12.0-319.0.dev
- **Riverpod v3** (`riverpod_annotation` + `riverpod_generator`) for state management
- **GoRouter** with `ShellRoute` for navigation — ShellRoute wraps the 5-tab main UI
- **Supabase** (Auth, PostgreSQL, Realtime, Storage) as backend
- **Mapbox Maps** for the map feature
- **Freezed** for immutable data models with JSON serialization

### Directory Structure
```
lib/
├── main.dart
├── app.dart                     # HaloApp (MaterialApp.router)
├── core/
│   ├── constants/                # AppColors, AppSizes, SupabaseConstants, MapboxConstants, Env
│   ├── router/app_router.dart    # GoRouter configuration
│   ├── theme/                    # AppTheme (dark theme, neon accents)
│   ├── utils/                    # Extensions
│   └── widgets/                  # Shared: HaloAvatar, HaloButton, HaloTextField, LoadingOverlay
└── features/
    └── {auth,chat,friends,map,profile,status,weather}/
        └── each feature has: data/, domain/, presentation/providers/, presentation/screens/
```

### Navigation Pattern
The main UI uses an `IndexedStack` inside a custom `_MainShell` via `ShellRoute`. All 5 tab screens (Map, Friends, Chat, Status, Profile) are kept alive simultaneously — the MapScreen's geolocator stream continues running in the background when switching tabs. Full-screen routes (ChatRoomScreen, EditProfileScreen, AddFriendScreen, NotificationScreen, PrivacyScreen) use a custom slide transition page builder.

### Provider Patterns
- **`keepAlive: true` providers**: Use `@Riverpod(keepAlive: true)` for long-lived state like `AuthNotifier`
- **autoDispose async providers**: When using `async` values with autoDispose, fetch dependencies before the async gap and call `ref.keepAlive()` in `try-finally` to prevent disposal during await. This pattern is established in the Status module and should be replicated consistently across all async providers.
- Use `AsyncValue.guard()` for clean error handling in notifier action methods.

### Database Schema (Supabase)
Key tables: `profiles` (1:1 with auth.users), `friendships` (self-referencing), `chat_rooms`, `chat_room_members`, `messages` (text/sticker/location types). Full schema including indexes, triggers, RLS policies, and storage buckets is in `supabase/migrations/20260513164206_initial_schema.sql`.

### Known MVP Limitations
- Chat and Friends features use static mock data — repositories have realtime blocks that are commented out and need activation against live Supabase.
- App currently runs in "Guest/Local mode" without live Supabase credentials.
- Push notifications via FCM are not yet integrated.