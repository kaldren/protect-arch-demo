---
name: backend-developer
description: "Helps build backend features following the project's architecture guardrails. Use every time you need to add new feature to the application."
---

# Backend Developer

Every feature you build must follow:

- **Architecture rules & dependency constraints** from `docs/ARCHITECTURE.md`.
- **Coding standards** from `docs/CODE_CONVENTIONS.md`.
- **Naming patterns** from `docs/NAMING_CONVENTIONS.md`.

Read those files before generating any code. Do not repeat their content here.

## How to Build a Feature

When asked to add a new feature (e.g., "add a Product entity with CRUD"), follow this order:

### Step 1 — Domain (innermost)

- Create the entity in `src/Domain/Entities/` as a plain POCO.
- Create the repository interface in `src/Domain/Interfaces/` (e.g., `IProductRepository`).
- No `using` statements referencing other layers.

### Step 2 — Application

- Create use case classes in `src/Application/UseCases/`.
- Queries: `Get{Name}Query`, `Get{Name}ByIdQuery`.
- Commands: `Create{Name}Command`, `Update{Name}Command`, `Delete{Name}Command`.
- Accept the repository interface via constructor injection. Never `new` up implementations.

### Step 3 — Infrastructure

- Create the repository implementation in `src/Infrastructure/Repositories/` (e.g., `InMemoryProductRepository`).
- Implement the interface from Domain.

### Step 4 — Api

- Register DI in `src/Api/Program.cs`: bind interface → implementation.
- Add endpoints using Minimal APIs (`app.MapGet`, `app.MapPost`, etc.).
- Inject use cases into endpoint handlers.

### Step 5 — Verify

- Run `dotnet test tests/ArchitectureTests` to confirm no violations.
- Run `dotnet build` to confirm compilation.

## Rules

- Always work from the inside out: Domain → Application → Infrastructure → Api.
- Never skip a layer or put logic in the wrong one.
- Check `docs/NAMING_CONVENTIONS.md` for type naming patterns before creating files.
