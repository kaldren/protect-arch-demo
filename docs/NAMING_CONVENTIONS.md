# Naming Conventions — Quick Reference

A compact reference card for naming rules across the project.

## Project / Layer Names

| Project        | Namespace Root   | Purpose                        |
| -------------- | ---------------- | ------------------------------ |
| Domain         | `Domain`         | Entities, interfaces           |
| Application    | `Application`    | Use cases, business logic      |
| Infrastructure | `Infrastructure` | Data access, external services |
| Api            | `Api`            | HTTP endpoints, DI composition |

## Type Naming Patterns

| Pattern                           | Example                          | Layer       |
| --------------------------------- | -------------------------------- | ----------- |
| `{Name}` (entity)                 | `WeatherForecast`                | Domain      |
| `I{Name}Repository`               | `IWeatherRepository`             | Domain      |
| `Get{Name}Query`                  | `GetWeatherForecastsQuery`       | Application |
| `Get{Name}ByIdQuery`              | `GetWeatherForecastByIdQuery`    | Application |
| `Create{Name}Command`             | `CreateWeatherForecastCommand`   | Application |
| `Update{Name}Command`             | `UpdateWeatherForecastCommand`   | Application |
| `Delete{Name}Command`             | `DeleteWeatherForecastCommand`   | Application |
| `{Store}{Name}Repository`         | `InMemoryWeatherRepository`      | Infra       |
| `{Name}Controller` or Minimal API | `app.MapGet("/weatherforecast")` | Api         |

## Namespace Structure

```
Domain.Entities.WeatherForecast
Domain.Interfaces.IWeatherRepository
Application.UseCases.GetWeatherForecastsQuery
Infrastructure.Repositories.InMemoryWeatherRepository
```

## Do's and Don'ts

- **Do** prefix interfaces with `I`.
- **Do** suffix async methods with `Async`.
- **Do** match file name to type name.
- **Don't** use abbreviations (`Repo`, `Svc`, `Mgr`) — spell it out.
- **Don't** use Hungarian notation (`strName`, `intCount`).
- **Don't** prefix private fields with `m_` — use `_camelCase`.
