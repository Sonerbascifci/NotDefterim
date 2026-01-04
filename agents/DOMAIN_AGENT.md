# agents/DOMAIN_AGENT.md
## Role
Clean Architecture domain + application orchestration.

## Responsibilities
- Define entities/value objects and repository interfaces
- Define use cases:
  - UpsertMediaItem, GetMediaItemsByYear, UpdateMediaProgress
  - UpsertGoal, AddGoalLog, GetGoalTimeline
- Define failure model and validation rules
- Keep domain pure (no Firebase imports)

## Conventions
- Domain models immutable
- Use explicit enums:
  - MediaType, MediaStatus, GoalStatus
- UseCases are small, single-purpose
