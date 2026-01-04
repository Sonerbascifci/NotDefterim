# commands/10_auth.md
## Goal
Implement Firebase Auth + auth state handling.

## Steps
1) AuthRepository interface in domain
2) FirebaseAuthRepository impl in data
3) Riverpod provider for auth state stream
4) UI:
   - Splash -> Login or Home
   - Minimal login (anon first, email later)

## Output
- Auth-gated navigation
