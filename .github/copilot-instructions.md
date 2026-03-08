# Project: Protect Arch Demo

This project follows **Clean Architecture** principles. All contributions — human or AI — must respect the layered dependency rules.

## Architecture Layers (innermost → outermost)

1. **Domain** (`src/Domain`) — Entities and repository interfaces. Zero dependencies on other project layers.
2. **Application** (`src/Application`) — Use cases / business logic. Depends only on Domain.
3. **Infrastructure** (`src/Infrastructure`) — Data access, external services. Depends on Domain and Application.
4. **Api** (`src/Api`) — HTTP layer, DI composition root. Depends on Application and Infrastructure.

## Dependency Rules — NEVER violate these

| Layer          | May reference               | Must NEVER reference             |
| -------------- | --------------------------- | -------------------------------- |
| Domain         | (nothing)                   | Application, Infrastructure, Api |
| Application    | Domain                      | Infrastructure, Api              |
| Infrastructure | Domain, Application         | Api                              |
| Api            | Application, Infrastructure | —                                |

## Coding Guidelines

- Use **C# 12** with file-scoped namespaces.
- Keep Domain entities as plain POCOs — no framework dependencies.
- Repository **interfaces** live in `Domain/Interfaces`; **implementations** live in `Infrastructure/Repositories`.
- Use cases live in `Application/UseCases` and accept interfaces via constructor injection.
- The Api project is the only place that configures DI and middleware — never register services elsewhere.
- All new code must pass the architecture tests in `tests/ArchitectureTests` (run with `dotnet test`).
- Follow the conventions in `docs/CODE_CONVENTIONS.md` and `docs/NAMING_CONVENTIONS.md`.
