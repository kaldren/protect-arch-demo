# Code Conventions

This document defines the coding standards for the project. All contributors — human and AI — must follow these rules.

## Language & Framework

- **C# 12** or later with **.NET 10**.
- **File-scoped namespaces** — one namespace declaration per file, no braces.
- **Nullable reference types** enabled (`<Nullable>enable</Nullable>`).
- **Implicit usings** enabled — do not add global `using` statements for default namespaces.

## Naming Conventions

| Element            | Style            | Example              |
| ------------------ | ---------------- | -------------------- |
| Namespace          | PascalCase       | `Domain.Entities`    |
| Class / Record     | PascalCase       | `WeatherForecast`    |
| Interface          | `I` + PascalCase | `IWeatherRepository` |
| Method             | PascalCase       | `GetAllAsync()`      |
| Property           | PascalCase       | `TemperatureC`       |
| Private field      | `_camelCase`     | `_repository`        |
| Local variable     | camelCase        | `forecast`           |
| Constant           | PascalCase       | `MaxRetryCount`      |
| Enum               | PascalCase       | `TemperatureUnit`    |
| Enum member        | PascalCase       | `Celsius`            |
| Generic type param | `T` + PascalCase | `TEntity`            |
| Async methods      | Suffix `Async`   | `GetByIdAsync()`     |

## File & Folder Conventions

- **One type per file.** The file name must match the type name (e.g., `WeatherForecast.cs`).
- **Folder = namespace.** The folder structure mirrors the namespace hierarchy.
- **Layer placement rules:**

| What                       | Where                          |
| -------------------------- | ------------------------------ |
| Entities / Value Objects   | `Domain/Entities/`             |
| Repository interfaces      | `Domain/Interfaces/`           |
| Use cases / Queries / Cmds | `Application/UseCases/`        |
| Repository implementations | `Infrastructure/Repositories/` |
| DI registration            | `Api/Program.cs`               |

## Use Case Conventions

- Name query classes as `Get{Thing}{Query|ById}Query` (e.g., `GetWeatherForecastsQuery`).
- Name command classes as `{Verb}{Thing}Command` (e.g., `CreateWeatherForecastCommand`).
- Accept dependencies via **constructor injection** — never use `new` for services.
- Use cases must depend only on interfaces from `Domain/Interfaces/`, never on concrete implementations.

## Dependency Injection

- All DI registration happens **exclusively** in `Api/Program.cs`.
- Register services with the narrowest lifetime that works:
  - `AddSingleton` — stateless services, caches.
  - `AddScoped` — per-request services (repositories, unit of work).
  - `AddTransient` — lightweight, stateless helpers.
- Bind interfaces to implementations (`builder.Services.AddSingleton<IWeatherRepository, InMemoryWeatherRepository>()`).

## Error Handling

- Do not swallow exceptions — let them propagate or handle them explicitly.
- Use `ILogger<T>` for logging — never `Console.WriteLine`.
- Return appropriate HTTP status codes from endpoints (400 for bad input, 404 for not found, 500 for unhandled).

## Async / Await

- Prefer `async`/`await` for I/O-bound operations.
- Suffix all async methods with `Async`.
- Never use `.Result` or `.Wait()` — it causes deadlocks.

## General

- Keep methods short — prefer under 20 lines.
- Avoid `#region` blocks.
- No commented-out code in committed files.
- Prefer `var` when the type is obvious from the right-hand side.
- Use `record` types for immutable data transfer objects.
