```skill
---
name: coding-standards
description: "C# coding standards, naming conventions, async patterns, error handling, and security rules for the project. Use whenever writing, reviewing, or validating code quality."
---

# Coding Standards

This skill provides the canonical code quality rules. All agents writing or reviewing code must follow these — always derive specifics from the source docs.

## Source of Truth

- `docs/CODE_CONVENTIONS.md` — full coding standards.
- `docs/NAMING_CONVENTIONS.md` — naming patterns and do's/don'ts.

## Code Style

- **C# 12+** with **.NET 10**.
- **File-scoped namespaces** — one per file, no braces.
- **Nullable reference types** enabled.
- **Implicit usings** enabled — no redundant global `using` statements.
- **One type per file** — file name must match type name.
- Prefer `var` when the type is obvious from the right-hand side.
- Use `record` types for immutable DTOs.
- No commented-out code, no `#region` blocks.
- Keep methods under 20 lines where possible.

## Naming

- Classes/records: `PascalCase`.
- Interfaces: `I` + `PascalCase` (e.g., `IWeatherRepository`).
- Async methods: suffix with `Async` (e.g., `GetByIdAsync`).
- Private fields: `_camelCase`.
- No abbreviations (`Repo`, `Svc`, `Mgr`) — spell them out.
- Type naming patterns per layer are defined in `docs/NAMING_CONVENTIONS.md`.

## Dependency Injection

- All DI registration in `Api/Program.cs` only.
- Constructor injection — never `new` up services.
- Use narrowest lifetime: `AddSingleton` → `AddScoped` → `AddTransient`.

## Async / Await

- Use `async`/`await` for I/O-bound operations.
- Never use `.Result` or `.Wait()`.
- Async methods must return `Task` or `Task<T>`.

## Error Handling

- Do not swallow exceptions.
- Use `ILogger<T>` for logging — never `Console.WriteLine`.
- Return appropriate HTTP status codes (400, 404, 500).

## Security

- No hardcoded secrets, connection strings, or API keys.
- Parameterised queries or ORM for data access.
- Input validation on all API endpoints.
- No sensitive data in logs.

```
