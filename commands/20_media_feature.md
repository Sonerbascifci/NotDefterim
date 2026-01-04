# commands/20_media_feature.md
## Goal
Implement Media tracking MVP.

## Query needs
- By year + type + status
- Search by title (client-side initially)

## Steps
1) Entity: MediaItem
2) Repo: MediaRepository
3) Firestore paths: users/{uid}/media_items
4) Controllers/providers:
   - listProvider(year,type,status)
   - upsertProvider
5) UI:
   - List with filters
   - Detail + edit
   - Add flow via FAB

## Output
- Fully functional media module
