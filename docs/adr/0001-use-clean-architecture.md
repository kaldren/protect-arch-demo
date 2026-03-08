# ADR-0001: Use Clean Architecture

## Status

Accepted

## Date

2025-06-15

## Context

We need a consistent architecture pattern for the project that:

- Separates business logic from infrastructure concerns
- Makes the codebase testable at every layer
- Allows swapping data access, frameworks, or delivery mechanisms without rewriting core logic
- Provides clear dependency rules that can be enforced automatically

Several options were considered: Layered Architecture, Vertical Slices, Hexagonal Architecture, and Clean Architecture.

## Decision

We will use **Clean Architecture** with four layers:

1. **Domain** — Entities, value objects, and repository interfaces. Zero dependencies on other layers.
2. **Application** — Use cases and business logic. Depends only on Domain.
3. **Infrastructure** — Data access, external services, and repository implementations. Depends on Domain and Application.
4. **Api** — HTTP layer and DI composition root. Depends on Application and Infrastructure.

Dependencies flow **inward only** — outer layers depend on inner layers, never the reverse.

## Consequences

- All business rules are isolated and framework-independent.
- The Domain layer can be unit-tested without any infrastructure.
- Swapping a data store (e.g., in-memory → SQL → Cosmos DB) only affects Infrastructure.
- New developers must learn the layer boundaries, but this is mitigated by architecture tests and AI guardrails.
- Adds more projects/files than a simple layered approach, which is acceptable for the maintainability benefits.
