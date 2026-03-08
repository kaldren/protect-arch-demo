# Contributing

Thank you for contributing to the Protect Arch Demo project. Please follow these guidelines.

## Before You Start

1. Read the [Code Conventions](docs/CODE_CONVENTIONS.md) and [Naming Conventions](docs/NAMING_CONVENTIONS.md).
2. Understand the [Clean Architecture layers](docs/adr/0001-use-clean-architecture.md) and their dependency rules.
3. Familiarise yourself with the architecture tests in `tests/ArchitectureTests/`.

## Development Workflow

1. Create a feature branch from `main`: `git checkout -b feature/your-feature`.
2. Make your changes, keeping each commit focused on a single concern.
3. Run the architecture tests before pushing:
   ```bash
   dotnet test tests/ArchitectureTests
   ```
4. Open a Pull Request against `main`.

## Commit Messages

Use the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
feat: add CreateWeatherForecastCommand use case
fix: correct null check in InMemoryWeatherRepository
docs: add ADR for caching strategy
test: add naming convention architecture tests
refactor: extract endpoint mapping to extension method
```

## Architecture Rules

Every change must respect the dependency rules:

| Layer          | May reference               | Must NEVER reference             |
| -------------- | --------------------------- | -------------------------------- |
| Domain         | (nothing)                   | Application, Infrastructure, Api |
| Application    | Domain                      | Infrastructure, Api              |
| Infrastructure | Domain, Application         | Api                              |
| Api            | Application, Infrastructure | —                                |

If your change adds a new project or external dependency, discuss it in an issue first and document the decision in a new ADR under `docs/adr/`.

## Adding an ADR

Use the format: `docs/adr/NNNN-short-title.md` with sections: Status, Date, Context, Decision, Consequences. See existing ADRs for examples.
