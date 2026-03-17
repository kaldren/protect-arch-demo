---
name: Error Handling & Logging
description: Exception handling patterns, ProblemDetails responses, structured logging with ILogger, and correlation IDs.
applyTo: "src/**/*.cs"
---

# Error Handling & Logging Guidelines

These rules expand on the error handling section in `docs/CODE_CONVENTIONS.md`.

## Exception Strategy by Layer

### Domain Layer
- Define custom exception types for domain-specific failures (e.g., `EntityNotFoundException`, `DomainValidationException`).
- Throw exceptions with descriptive messages that include the entity type and identifier.
- Never throw generic `Exception` or `ApplicationException`.

### Application Layer
- Validate inputs at the start of every use case — fail fast with clear messages.
- Catch domain exceptions only if the use case needs to translate them into a different outcome.
- Let unexpected exceptions propagate — do not swallow them.

### Infrastructure Layer
- Wrap third-party/external service exceptions in domain-meaningful exceptions.
- Include the original exception as an inner exception for diagnostic context.
- Log the full exception details at `Error` level before re-throwing.

### API Layer
- Use a **global exception handler middleware** to catch unhandled exceptions and return consistent `ProblemDetails` responses.
- Never let raw exception details (stack traces, internal messages) leak to API consumers.
- Map exceptions to HTTP status codes consistently:

| Exception Type             | HTTP Status | Example                        |
| -------------------------- | ----------- | ------------------------------ |
| `EntityNotFoundException`  | 404         | Resource not found             |
| `DomainValidationException`| 400 / 422   | Invalid input data             |
| `UnauthorizedAccessException` | 401 / 403 | Authentication/authorization   |
| Unhandled / unexpected     | 500         | Internal server error          |

## ProblemDetails (RFC 9457)

- All error responses must use the `ProblemDetails` format.
- Include `type`, `title`, `status`, and `detail` fields at minimum.
- Use `builder.Services.AddProblemDetails()` and `app.UseExceptionHandler()` in `Program.cs`.

## Structured Logging

- Use `ILogger<T>` — inject via constructor, never use `Console.WriteLine`.
- Use **log message templates** with named placeholders, not string interpolation:
  ```csharp
  // Correct
  _logger.LogInformation("Fetching forecast {ForecastId}", id);
  
  // Wrong — prevents structured log queries
  _logger.LogInformation($"Fetching forecast {id}");
  ```
- Log levels:
  - `Debug` — Detailed diagnostic info (disabled in production).
  - `Information` — Normal application flow (request received, operation completed).
  - `Warning` — Expected but unusual conditions (retry, fallback).
  - `Error` — Unexpected failures that need investigation.
  - `Critical` — Application-wide failures (startup failure, data corruption).

## Correlation & Tracing

- Include correlation IDs in log entries for request tracing across services.
- Use `Activity.Current?.Id` or a custom middleware to propagate trace context.
- Log the correlation ID at the start and end of each request.

## Anti-Patterns to Avoid

- **Empty catch blocks** — always log or re-throw.
- **Catching `Exception`** broadly — catch specific types.
- **Logging and re-throwing** the same exception at multiple layers (creates duplicate log entries).
- **Using exceptions for control flow** — use return types or result patterns instead.
