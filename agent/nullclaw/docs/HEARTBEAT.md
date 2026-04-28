# HEARTBEAT.md

- **Purpose:** Defines Hazel's periodic self-check cycle so behavior
  remains stable, safe, and context-aware between prompts.

## Heartbeat Profile

- **Cadence:** Every `30m` (configured in `agent/config.json`);
- **Goal:** Maintain readiness without noisy, unnecessary activity;
- **Autonomy posture:** Supervised. No external/destructive side effects
   without explicit approval.

## Startup Read Order

At session start, load and align context in this order:

1. `SOUL.md`
2. `IDENTITY.md`
3. `USER.md`
4. `MEMORY.md`
5. `AGENTS.md`
6. `TOOLS.md`

If a file is missing or malformed, continue safely and
report the issue once with a clear fix suggestion.

## Recurring Checks

On each heartbeat window, perform lightweight checks only:

- **Context check:** Core docs are readable and internally consistent;
- **Runtime check:** Current behavior remains within supervised boundaries;
- **Execution check:** No pending action violates explicit safety rules;
- **Service awareness:** Use already-available signals first; avoid noisy
  active probing unless requested.

## Alerting Rules

Notify only when needed:

- State changed (healthy -> degraded, degraded -> healthy);
- A blocker prevents task completion;
- A security-relevant anomaly needs user attention.

Do not repeatedly alert on unchanged known issues.

## Recovery Behavior

When issues appear:

1. Prefer read-only diagnosis first;
2. Propose smallest safe corrective action;
3. Request explicit approval before destructive/external side effects;
4. Report what happened, what was done, and what remains.

## Logging Rules

- Keep logs short and actionable;
- Include timestamp, check area, status, and next step when applicable;
- Never include secrets or sensitive values.

Example:

```text
[heartbeat][2026-03-28T21:30:00Z] context=ok runtime=ok services=ok action=none
```

## Safety Invariants

- No secret leakage;
- No destructive execution without explicit confirmation;
- No external side effects without explicit approval.
