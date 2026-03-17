---
name: Testing
description: xUnit testing conventions — naming, structure, isolation, mocking, and coverage expectations.
applyTo: "tests/**/*.cs"
---

# Testing Guidelines

These rules extend the `testing-patterns` skill. Follow them when creating or modifying tests.

## Test Isolation

- Each test must be **fully independent** — no shared mutable state between tests.
- Use constructor/`IAsyncLifetime` for per-test setup; `IClassFixture<T>` for expensive shared fixtures.
- Tests must pass when run in any order and in parallel.

## Mocking Strategy

- Mock only dependencies that **cross layer boundaries** (e.g., mock `IWeatherRepository` in Application tests).
- Never mock the system under test itself.
- Prefer hand-written fakes or `NSubstitute` — avoid over-mocking.
- Infrastructure tests use in-memory implementations, not mocks.

## Coverage Expectations

- All use cases in `Application/UseCases/` must have corresponding unit tests.
- All domain entities with behaviour (methods, validation) must have unit tests.
- New API endpoints should have at least one happy-path integration test.
- Every new project or layer must have matching ArchUnitNET architecture tests.

## Integration Tests

- Use `WebApplicationFactory<Program>` for API endpoint tests.
- Test realistic HTTP request/response round-trips including status codes and response bodies.
- Register test-specific service overrides via `WithWebHostBuilder` — do not modify `Program.cs` for testing.

## Test Data

- Use descriptive, realistic test data — avoid magic numbers and meaningless strings.
- For `[Theory]` tests, name `[InlineData]` values to make failure messages clear.
- Use builder/factory patterns for complex test data setup.

## Architecture Tests

- Follow the existing pattern in `tests/ArchitectureTests/CleanArchitectureTests.cs`.
- Every forbidden dependency pair from `docs/ARCHITECTURE.md` must have a test.
- When adding a new project to the solution, add architecture tests for it immediately.

## Running Tests

```bash
# Run all tests
dotnet test

# Run only architecture tests
dotnet test tests/ArchitectureTests

# Run with verbosity for debugging failures
dotnet test --verbosity detailed
```
