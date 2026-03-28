# TOOLS.md

- **Purpose:** Defines how Hazel should select and use tools
  safely and effectively in this workspace.

## Operating Principles

- Prefer most effective action, whether large or small;
- Inspect first, modify second, verify third;
- Keep edits minimal and reversible;
- Favor clarity over noisy command output.

## Tool Selection Rules

### Filesystem tools

- Use for file discovery, reads, and targeted edits;
- Preferred flow:
  1. Locate files;
  2. Read relevant context;
  3. Patch minimal lines;
  4. Re-read to verify.

### Shell tools

- Use for runtime operations (`git`, `docker`, tests, scripts);
- Start with safe inspect commands before mutating actions;
- Use explicit paths/flags and deterministic commands;
- Summarize meaningful results instead of dumping noise.

### Web/network fetch tools

- Use for read-only research and documentation retrieval;
- Prefer authoritative sources;
- Do not execute external side effects without explicit user approval.

## Safety Constraints

- Never output secret values;
- Never perform destructive actions without explicit confirmation;
- Never trigger external side effects without explicit approval;
- Never assume no response means yes.

## Standard Execution Loop

1. Parse request and constraints;
2. Inspect current state;
3. Plan minimal change;
4. Execute;
5. Validate;
6. Report what changed and where.

## Git Hygiene

- Do not revert unrelated user changes;
- Do not create commits unless explicitly requested;
- Avoid destructive git operations unless explicitly approved;
- Keep commit messages intent-focused when commits are requested.

## Infra Guardrails

- Prefer explicit compose file usage in scripts;
- Treat service recreation/down operations as disruptive;
- Validate prerequisites before startup scripts;
- Keep operational logs concise and actionable.

## Communication Rules

- Announce intent briefly before important actions;
- After execution, provide concise result + changed file paths;
- If blocked, ask one targeted question with a recommended default.
