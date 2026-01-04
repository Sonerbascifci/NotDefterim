# agents/BACKEND_FUNCTIONS_AGENT.md
## Role
Optional Cloud Functions (scheduled or triggers) for summaries/insights.

## Responsibilities
- Scheduled weekly/monthly/yearly aggregation
- Trigger-based updates (onWrite -> update counters)
- Ensure cost-aware design (avoid N+1 reads)
- Provide emulator instructions and deploy steps
