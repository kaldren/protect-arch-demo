using Domain.Entities;

namespace Domain.Interfaces;

public interface IWeatherRepository
{
    Task<IEnumerable<WeatherForecast>> GetForecastsAsync();
    Task<WeatherForecast?> GetByIdAsync(Guid id);
}
