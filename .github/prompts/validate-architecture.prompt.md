---
description: 'Quick-check .csproj files for forbidden project references.'
---

# Validate Architecture

Your only job is to check each `.csproj` file under `src/` for forbidden `<ProjectReference>` entries.

## Rules

1. Read the dependency rules table in `docs/ARCHITECTURE.md` — that is the single source of truth.
2. Open every `.csproj` under `src/` and compare its `<ProjectReference>` entries against the "Must NEVER reference" column.
3. Do not provide additional commentary or suggestions — only report violations.

## Output

If violations exist, list them in a table:

| Project  | Forbidden Reference |
| -------- | ------------------- |
| `Domain` | `Application`       |

If no violations exist, respond with:

> ✅ No violations found.
