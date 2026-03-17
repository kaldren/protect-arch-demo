---
name: API Design
description: REST conventions for Minimal APIs — endpoint naming, HTTP verbs, status codes, DTOs, and endpoint organization.
applyTo: "src/Api/**/*.cs"
---

# API Design Guidelines

These rules apply to all HTTP endpoints in the Api layer.

## Minimal API Conventions

- Use `app.MapGroup()` to organize related endpoints under a common prefix.
- Use `TypedResults` for compile-time response type verification:
  ```csharp
  app.MapGet("/weatherforecasts/{id}", (int id, GetWeatherForecastByIdQuery query) =>
  {
      var result = query.Execute(id);
      return result is not null ? TypedResults.Ok(result) : TypedResults.NotFound();
  });
  ```
- Inject use cases directly into endpoint handlers via parameter binding.
- Keep endpoint handler bodies short — delegate business logic to use cases.

## Resource Naming

- Use **plural nouns** for collection endpoints: `/weatherforecasts`, `/weatherstations`.
- Use **kebab-case** for multi-word resources: `/weather-stations` (not camelCase or snake_case).
- Use path parameters for resource identification: `/weatherforecasts/{id}`.
- Use query parameters for filtering, sorting, and pagination: `?skip=0&take=10`.

## HTTP Verb Semantics

| Verb     | Purpose               | Idempotent | Request Body | Example                        |
| -------- | --------------------- | ---------- | ------------ | ------------------------------ |
| `GET`    | Read resource(s)      | Yes        | No           | `GET /weatherforecasts`        |
| `POST`   | Create resource       | No         | Yes          | `POST /weatherforecasts`       |
| `PUT`    | Full update           | Yes        | Yes          | `PUT /weatherforecasts/{id}`   |
| `PATCH`  | Partial update        | No         | Yes          | `PATCH /weatherforecasts/{id}` |
| `DELETE` | Remove resource       | Yes        | No           | `DELETE /weatherforecasts/{id}`|

## Response Status Codes

| Scenario                  | Status Code      | Response Body           |
| ------------------------- | ---------------- | ----------------------- |
| Successful read           | `200 OK`         | Resource or collection  |
| Successful creation       | `201 Created`    | Created resource + `Location` header |
| Successful delete/update  | `204 No Content` | None                    |
| Bad/invalid input         | `400 Bad Request`| `ProblemDetails`        |
| Not authenticated         | `401 Unauthorized`| `ProblemDetails`       |
| Not authorized            | `403 Forbidden`  | `ProblemDetails`        |
| Resource not found        | `404 Not Found`  | `ProblemDetails`        |
| Validation failure        | `422 Unprocessable`| `ProblemDetails`      |
| Server error              | `500 Internal`   | `ProblemDetails`        |

## DTOs & Mapping

- **Never** expose domain entities directly in API responses.
- Create request/response DTOs (use `record` types) at the API boundary.
- Map between domain entities and DTOs in the endpoint handler or a mapping extension method.
- Keep DTOs specific to their endpoint — avoid "god DTOs" that serve multiple purposes.

## Endpoint Organization

- Group endpoints by resource in separate static classes or extension methods.
- Register endpoint groups in `Program.cs` for discoverability.
- Use endpoint filters for cross-cutting concerns (validation, logging, auth).
- Document endpoints in `Api.http` for manual testing with the VS Code REST Client.
