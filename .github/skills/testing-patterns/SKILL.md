````skill
---
name: testing-patterns
description: "xUnit testing conventions, test project setup, ArchUnitNET architecture tests, and test naming patterns. Use whenever creating, reviewing, or running tests."
---

# Testing Patterns

This skill provides the canonical testing conventions for the project. All agents creating or reviewing tests must follow these rules.

## Test Framework

- **xUnit** for all tests.
- **ArchUnitNET** for architecture tests.
- Use `[Fact]` for single-case tests, `[Theory]` with `[InlineData]` for parameterised tests.
- Async test methods must return `Task`.

## Test Naming

- Test class: `{ClassUnderTest}Tests` (e.g., `GetProductsQueryTests`).
- Test method: `{Method}_{Scenario}_{ExpectedResult}` (e.g., `Execute_WithValidId_ReturnsProduct`).

## Test Structure

Use the **Arrange-Act-Assert** pattern. One assertion per test where practical.

## Test Categories by Layer

| Layer          | What to test                      | Mocking                          | Location                     |
| -------------- | --------------------------------- | -------------------------------- | ---------------------------- |
| Domain         | Entity behaviour, validation      | None needed                      | `tests/DomainTests/`         |
| Application    | Use cases (queries, commands)     | Mock `Domain/Interfaces/`        | `tests/ApplicationTests/`    |
| Infrastructure | Repository implementations        | In-memory data                   | `tests/InfrastructureTests/` |
| Api            | Endpoints (HTTP status, response) | `WebApplicationFactory<Program>` | `tests/ApiTests/`            |
| Architecture   | Dependency rule enforcement       | ArchUnitNET                      | `tests/ArchitectureTests/`   |

## Architecture Test Pattern

Follow the existing pattern in `tests/ArchitectureTests/CleanArchitectureTests.cs`:

```csharp
[Fact]
public void Layer_Should_Not_Depend_On_ForbiddenLayer()
{
    Types().That().Are(SourceLayer)
        .Should().NotDependOnAny(ForbiddenLayer)
        .Because("Reason from ARCHITECTURE.md")
        .Check(Architecture);
}
````

## New Test Project Setup

1. `dotnet new xunit -n {Name} -o tests/{Name}`
2. Set `<TargetFramework>net10.0</TargetFramework>`, `<Nullable>enable</Nullable>`, `<ImplicitUsings>enable</ImplicitUsings>`.
3. Add `<ProjectReference>` to the project under test.
4. Add to solution: `dotnet sln add tests/{Name}`.

## Rules

- Never skip architecture tests — always include them in the test run.
- All tests must pass before reporting completion.
- Use mocks/stubs — never depend on external services in unit tests.
- Run `dotnet test` to verify everything passes.

```

```
