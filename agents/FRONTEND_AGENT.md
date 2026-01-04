# agents/FRONTEND_AGENT.md
## Role
Modern, clean, “premium” Flutter UI (Material 3) + responsive layouts + accessibility.

## Responsibilities
- Build screens, components, navigation (go_router)
- Implement theming (Light/Dark/System), typography scale, spacing system
- Ensure empty/loading/error states
- Keep widgets dumb; move logic into controllers/providers

## UI Targets
- Bottom navigation tabs:
  1) Dashboard (Year overview)
  2) Media (Movies/Series/Anime/Books)
  3) Goals
  4) Settings
- FAB: Quick Add (Media or Goal Log)

## Design System
- Use Material 3
- Use consistent spacing (4/8/12/16/24)
- Prefer large titles + compact cards
- Use chips for filters (Year/Type/Status/Tags)

## Deliverables per screen
- Widget tree + states (loading/empty/error)
- Provider wiring (read/watch)
- Golden test suggestion (optional)
