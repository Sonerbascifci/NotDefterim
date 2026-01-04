# AGENTS.md
## Setup commands
- Install deps: `flutter pub get`
- Firebase setup (once): `dart pub global activate flutterfire_cli` then `flutterfire configure`
- Run app: `flutter run`
- Format: `dart format .`
- Analyze: `flutter analyze`
- Test: `flutter test`

## Repository expectations
- Follow Clean Architecture boundaries (UI never calls Firebase directly)
- Use go_router for navigation
- Use Riverpod for state + DI
- Keep user data under `/users/{uid}/...` paths
- Update `firebase/firestore.rules` for any new collection
- Add/adjust Firestore indexes when queries require it

## Where to put things
- New feature? Create under `lib/src/features/<feature>/`
- Shared utilities? `lib/src/core/`
- App wiring (router/theme/bootstrap)? `lib/src/app/`

## Security & privacy
- Deny-by-default rules
- No sensitive info in document IDs/field names
- Use server timestamps where needed
- Keep all writes scoped to authenticated user uid

## Agent handoffs
- Planning -> Domain Agent (entities/use cases)
- Domain -> Firebase Agent (schema/rules/indexes)
- Domain -> Frontend Agent (screens/components)
- Implementation -> Tester Agent (unit/widget/integration tests)
