---
name: backend-developer
description: "Helps build backend features following the project's architecture guardrails. Use every time you need to add new feature to the application."
---

# Backend Developer

This skill provides the step-by-step procedure for building features. It assumes the `architecture-rules` and `coding-standards` skills are also loaded — do not restate their content.

## How to Build a Feature

When asked to add a new feature (e.g., "add a Product entity with CRUD"), follow the inside-out build order from the `architecture-rules` skill, applying these concrete actions at each layer:

### Step 1 — Domain

- Create the entity as a plain POCO.
- Create the repository interface.

### Step 2 — Application

- Create use case classes — queries and commands per the naming patterns in `docs/NAMING_CONVENTIONS.md`.

### Step 3 — Infrastructure

- Create the repository implementation (e.g., `InMemoryProductRepository`).

### Step 4 — Api

- Register DI bindings in `Program.cs`.
- Add endpoints using Minimal APIs (`app.MapGet`, `app.MapPost`, etc.).
- Inject use cases into endpoint handlers.

### Step 5 — Verify

- Run `dotnet test tests/ArchitectureTests` to confirm no violations.
- Run `dotnet build` to confirm compilation.
