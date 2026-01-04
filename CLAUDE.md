# CLAUDE.md
## Project: Not Defterim (Flutter + Firebase)

### Product Goal
A personal life-tracking notebook:
- Year-based tracking for Movies/Series/Anime/Books (planned / in-progress / completed / dropped)
- Goals (e.g., English, AI/Claude learning) with progress logs
- Insights: weekly/monthly/yearly summaries

### Tech Stack
- Flutter (Material 3)
- State management & DI: Riverpod 2.x (prefer code generation)
- Navigation: go_router
- Backend: Firebase (Auth, Firestore, Security Rules, optional Cloud Functions)
- Testing: flutter_test + integration_test (and Firebase emulator for rules)

### Architecture (Clean Architecture, feature-first)
We use a feature-first structure with clear layer boundaries.
- Presentation: UI widgets, screens, navigation, theming
- Application: controllers/view-models, orchestration, use cases (no direct Firebase calls)
- Domain: entities, value objects, repository interfaces, pure business rules
- Data: DTOs, mappers, repository implementations, Firebase data sources

#### Dependency direction
presentation -> application -> domain <- data
(data depends on domain interfaces, never the opposite)

### Folder Structure (proposed)
lib/
  src/
    app/                # app entry, router, theme, bootstrap
    core/               # shared utils, error handling, logging, constants
    features/
      auth/
        data/
        domain/
        presentation/
      media/
        data/
        domain/
        presentation/
      goals/
        data/
        domain/
        presentation/
      settings/
        data/
        domain/
        presentation/
test/
integration_test/
firebase/
  firestore.rules
  firestore.indexes.json
  functions/ (optional)

### Firebase Data Model (MVP)
All user-owned data lives under /users/{uid}/...
- users/{uid}
- users/{uid}/media_items/{mediaId}
- users/{uid}/goals/{goalId}
- users/{uid}/goal_logs/{logId}

### Non-negotiable Rules
- No business logic in Widgets. Widgets render state and dispatch intent only.
- No direct Firebase SDK calls from UI. Only via repositories (data layer).
- Every feature must have: entity + repository interface + repository impl + controller/provider.
- Prefer immutable models + explicit mapping (DTO <-> Entity).
- Add tests for domain rules and critical controllers.
- Security rules: deny by default; per-user access only.

### Workflow (How to implement a feature)
1) Write/confirm domain entities and repository interface
2) Implement data layer (Firestore paths, DTOs, mapping)
3) Implement application controller/provider (Riverpod)
4) Build presentation UI + routes
5) Add tests (unit + widget if critical)
6) Update security rules + indexes if needed

### Commands (canonical)
- Format: `dart format .`
- Analyze: `flutter analyze`
- Unit tests: `flutter test`
- Build runner (if used): `dart run build_runner build --delete-conflicting-outputs`
- Android build: `flutter build apk`
- iOS build: `flutter build ios`

### Code Style
- Keep files small and cohesive.
- Prefer explicit naming: *MediaItem*, *GoalLog*, *GetMediaByYearUseCase*.
- Errors: use a typed failure model (e.g., Failure(message, code)).
- Time: use UTC in storage; localize in UI.

### UI Principles
- Material 3, high-contrast, clean typography
- Light/Dark themes; ThemeMode follows system by default
- Bottom navigation for main sections; FAB for “quick add”
