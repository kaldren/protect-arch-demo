# ADR-0002: Use ArchUnitNET for Architecture Tests

## Status

Accepted

## Date

2025-06-15

## Context

Architecture rules documented in markdown are useful but not enforceable. Developers (and AI agents) can accidentally introduce dependency violations that go unnoticed until they cause problems.

We evaluated two libraries:

- **NetArchTest** — popular, simpler API, but less actively maintained.
- **ArchUnitNET** — port of the Java ArchUnit library, more expressive fluent API, actively maintained, better diagnostics.

## Decision

We will use **ArchUnitNET** (with xUnit) to write automated architecture tests that enforce dependency rules at build/test time.

Every forbidden dependency from our Clean Architecture rules must have a corresponding test. Tests run locally via `dotnet test` and are triggered automatically by the Copilot hook after file edits.

## Consequences

- Dependency violations are caught immediately — no reliance on code review alone.
- New rules can be added as new test methods with minimal effort.
- The test project must reference all source assemblies to scan them, which is acceptable.
- Developers must run `dotnet test tests/ArchitectureTests` before pushing (enforced by CI in the future).
