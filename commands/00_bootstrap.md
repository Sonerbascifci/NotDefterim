# commands/00_bootstrap.md
## Goal
Initialize project foundation with architecture wiring.

## Steps
1) Create folders under lib/src (app/core/features)
2) Add deps: riverpod, flutter_riverpod, go_router, firebase_core, firebase_auth, cloud_firestore
3) Implement app bootstrap:
   - Firebase.initializeApp
   - ProviderScope
   - MaterialApp.router with ThemeMode
4) Add basic router with 4 tabs scaffold
5) Add lint + format scripts

## Output
- Working app shell with tabs + theme switching
