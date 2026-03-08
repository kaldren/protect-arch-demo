# ADR-0003: Use Minimal APIs over Controllers

## Status

Accepted

## Date

2025-06-20

## Context

ASP.NET Core supports two approaches for defining HTTP endpoints:

- **Controllers** — class-based, convention-heavy, familiar from MVC.
- **Minimal APIs** — lambda-based, less ceremony, introduced in .NET 6.

Our API layer is thin — it only maps HTTP requests to use cases and returns results. There is no view rendering or complex model binding.

## Decision

We will use **Minimal APIs** in the Api project. Endpoints are defined directly in `Program.cs` (or in extension methods) using `app.MapGet()`, `app.MapPost()`, etc.

## Consequences

- Less boilerplate — no controller classes, no `[ApiController]` attributes.
- `Program.cs` serves as the single composition root for both DI and routing.
- For larger APIs, endpoints should be extracted into static extension methods to keep `Program.cs` manageable.
- Developers familiar only with controllers may need a brief orientation.
