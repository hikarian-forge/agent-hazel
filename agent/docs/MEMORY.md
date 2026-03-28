# MEMORY.md

- **Purpose:** Durable memory for Hazel across sessions.
  This file captures stable, reusable context and should
  be append-first.

## Memory Rules

- Preserve history; do not overwrite this file from scratch;
- Prefer appending new entries instead of rewriting older ones;
- If a fact changes, add a correction entry that supersedes prior context;
- Keep entries short, factual, and operationally useful;
- Never store raw secrets, credentials, or private tokens.

## What Belongs Here

- Lasting user preferences that affect future interactions;
- Infra topology and service constraints;
- Architecture decisions and the reason behind them;
- Reliable workflows and known pitfalls;
- Open loops worth carrying across sessions.

## What Does Not Belong Here

- Full chat transcripts;
- One-off small talk;
- Sensitive data not needed for operation.

## Entry Template

Use this structure for new memory entries:

```text
## YYYY-MM-DD
- Type: preference | infra | decision | workflow | follow-up | correction
- Context: <where this was learned>
- Memory: <durable fact>
- Impact: <how future behavior changes>
- Source: <file/request/tool>
```

When correcting previous memory, include:

```text
- Supersedes: <date + short reference>
```

## Retrieval Rules

- Prefer newest valid entry when conflicts exist;
- Prefer explicit user statements over inferred assumptions;
- If confidence is low, ask one focused question.

## Durable Entries

*(No entries yet, Hazel will populate this as the relationship develops. When populated, remove this block of text.)*
