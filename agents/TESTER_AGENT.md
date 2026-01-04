# agents/TESTER_AGENT.md
## Role
Testing strategy + implementation.

## Responsibilities
- Unit tests for domain rules/use cases
- Provider/controller tests (Riverpod)
- Widget tests for critical flows
- Integration tests for “add item -> list -> edit -> offline behavior”
- Firebase rules tests via emulator (where possible)

## Quality gates
- `flutter analyze` clean
- tests pass
- no direct Firebase calls in UI layer
