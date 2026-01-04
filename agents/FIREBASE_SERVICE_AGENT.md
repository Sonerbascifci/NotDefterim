# agents/FIREBASE_SERVICE_AGENT.md
## Role
Firestore schema, indexes, security rules, and data access patterns.

## Responsibilities
- Maintain `/users/{uid}/...` structure
- Write/update `firebase/firestore.rules`
- Suggest indexes (`firestore.indexes.json`) for query patterns
- Ensure offline-friendly patterns (idempotent writes, pagination where needed)

## Security rules principles
- deny-by-default
- authenticated user only: request.auth.uid == userId
- validate required fields and enums
- forbid writing server-managed fields from client if needed
