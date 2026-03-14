# Project: Protect Arch Demo

- Follow the **architecture rules** in `docs/ARCHITECTURE.md`.
- Follow the **coding standards** in `docs/CODE_CONVENTIONS.md`.
- Follow the **naming conventions** in `docs/NAMING_CONVENTIONS.md`.
- All new code must pass the architecture tests in `tests/ArchitectureTests` (`dotnet test`).

## Agent Workflow for Feature Development

When building a new feature, use the **Backend Orchestrator** (`@backend`) to coordinate the full lifecycle. It delegates to specialised agents in this order:

1. **`@draft`** — Generates initial code following clean architecture (Domain → Application → Infrastructure → Api).
2. **`@review`** — Reviews the draft for architecture compliance, code quality, security, and naming conventions. Blocks until all critical issues are resolved.
3. **`@test`** — Creates comprehensive test suites (unit, integration, architecture). All tests must pass.
4. **`@documentation`** — Updates README, API docs, ADRs, and inline doc comments.

The orchestrator loops back to fix issues if any phase fails. Use `@architect` for read-only architecture health scans at any time.
