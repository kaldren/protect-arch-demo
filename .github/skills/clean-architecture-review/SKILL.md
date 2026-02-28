---
name: clean-architecture-review
description: 'Reviews .NET code for Clean Architecture dependency violations. Use when reviewing code changes, pull requests, or validating that new code respects layer boundaries in a Clean Architecture project.'
---

# Clean Architecture Review

You are a specialist in Clean Architecture for .NET projects. When this skill is activated, perform a thorough review of the code for dependency rule violations.

## Architecture Layers

The project uses four layers (innermost → outermost):

1. **Domain** (`src/Domain`) — Entities, value objects, repository interfaces. **Zero** dependencies on other layers.
2. **Application** (`src/Application`) — Use cases and business logic. Depends only on Domain.
3. **Infrastructure** (`src/Infrastructure`) — Data access, external services. Depends on Domain and Application.
4. **Api** (`src/Api`) — HTTP endpoints, DI composition root. Depends on Application and Infrastructure.

## Review Checklist

For each source file, check the following:

### 1. Layer Identification

Determine which layer a file belongs to based on its path prefix:

- `src/Domain/` → Domain
- `src/Application/` → Application
- `src/Infrastructure/` → Infrastructure
- `src/Api/` → Api

### 2. Forbidden Dependencies

Check all `using` directives and type references:

| Layer          | Forbidden Dependencies           |
| -------------- | -------------------------------- |
| Domain         | Application, Infrastructure, Api |
| Application    | Infrastructure, Api              |
| Infrastructure | Api                              |
| Api            | (no restrictions)                |

### 3. Structural Rules

- Interfaces in `Domain/Interfaces/` must **only** be interfaces
- Repository implementations must live in `Infrastructure/Repositories/`
- Use cases must live in `Application/UseCases/`
- DI registration must only happen in `src/Api/Program.cs`

## How to Run Verification

Use the [architecture test script](./run-arch-tests.ps1) to execute automated verification:

```powershell
.\run-arch-tests.ps1
```

Or run directly:

```
dotnet test tests/ArchitectureTests --verbosity normal
```

## Output Format

Report findings as:

```
✅ PASS — No architecture violations found
```

or

```
❌ VIOLATION in [file path]
   Layer: [layer name]
   References: [forbidden namespace]
   Rule: [which rule is broken]
   Fix: [how to fix it]
```
