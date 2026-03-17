using Domain.Entities;

namespace Domain.Interfaces;

public interface IWeatherStationRepository
{
    Task<IEnumerable<WeatherStation>> GetAllAsync();
    Task<WeatherStation?> GetByIdAsync(Guid id);
}
