---
name: Performance
description: Async patterns, cancellation, pagination, caching, and memory-efficient coding for .NET.
applyTo: "src/**/*.cs"
---

# Performance Guidelines

These rules focus on runtime performance patterns for .NET applications.

## Async Best Practices

- Always accept and propagate `CancellationToken` through the full async call chain:
  ```csharp
  public async Task<WeatherForecast?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
  ```
- Never use `.Result`, `.Wait()`, or `.GetAwaiter().GetResult()` — these cause deadlocks and thread pool starvation.
- Prefer `ValueTask<T>` over `Task<T>` for methods that **frequently** complete synchronously (e.g., cache lookups).
- Use `ConfigureAwait(false)` in library code (Domain, Application, Infrastructure) but **not** in Api layer code.
- Use `IAsyncEnumerable<T>` for streaming large result sets instead of materialising entire collections.

## Pagination

- All list/collection endpoints **must** support pagination.
- Use `skip`/`take` (offset-based) or cursor-based pagination depending on the data source.
- Set sensible defaults (e.g., `take = 20`) and enforce maximum page sizes (e.g., `take <= 100`).
- Return pagination metadata in the response (total count, next/previous links) where appropriate.

## Caching

- Use `OutputCache` middleware or `ResponseCaching` for read-heavy GET endpoints.
- Apply `[OutputCache]` with appropriate duration and vary-by parameters.
- For data-layer caching, use `IMemoryCache` or `IDistributedCache` with explicit expiration policies.
- Always invalidate cache entries on write operations (POST, PUT, PATCH, DELETE).

## Memory Efficiency

- Avoid allocating large objects (>85 KB) that land on the Large Object Heap — use `ArrayPool<T>` for temporary buffers.
- Use `Span<T>` and `ReadOnlySpan<T>` for hot-path string/byte manipulation.
- Prefer `StringBuilder` over string concatenation in loops.
- Avoid capturing variables in closures unnecessarily — this creates hidden allocations.
- Use `sealed` on classes that are not designed for inheritance — enables devirtualisation.

## Database & I/O

- Use `AsNoTracking()` for read-only EF Core queries.
- Select only the columns needed — avoid `SELECT *` or loading full entity graphs.
- Use `AsSplitQuery()` for queries with multiple collection includes to avoid cartesian explosion.
- Batch multiple small writes into single transactions where possible.

## Startup Performance

- Use `WebApplication.CreateSlimBuilder()` if you don't need the full feature set.
- Register services with the correct lifetime — singletons for stateless services avoid repeated allocation.
- Prefer source-generated JSON serialisation (`JsonSerializerContext`) for reduced startup time and memory.
