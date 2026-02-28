using Domain.Entities;
using Domain.Interfaces;

namespace Infrastructure.Repositories;

public class InMemoryWeatherRepository : IWeatherRepository
{
    private static readonly string[] Summaries =
    [
        "Freezing", "Bracing", "Chilly", "Cool", "Mild",
        "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    ];

    private readonly List<WeatherForecast> _forecasts;

    public InMemoryWeatherRepository()
    {
        _forecasts = Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        }).ToList();
    }

    public Task<IEnumerable<WeatherForecast>> GetForecastsAsync()
    {
        return Task.FromResult<IEnumerable<WeatherForecast>>(_forecasts);
    }

    public Task<WeatherForecast?> GetByIdAsync(Guid id)
    {
        return Task.FromResult(_forecasts.FirstOrDefault(f => f.Id == id));
    }
}
