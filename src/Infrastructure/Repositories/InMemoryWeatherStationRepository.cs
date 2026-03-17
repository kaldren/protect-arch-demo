using Domain.Entities;
using Domain.Interfaces;

namespace Infrastructure.Repositories;

public class InMemoryWeatherStationRepository : IWeatherStationRepository
{
    private readonly List<WeatherStation> _stations =
    [
        new WeatherStation
        {
            Name = "Alpine Summit",
            Location = "Swiss Alps, Switzerland",
            Latitude = 46.5197,
            Longitude = 7.5647,
            IsActive = true
        },
        new WeatherStation
        {
            Name = "Coastal Watch",
            Location = "Cape Town, South Africa",
            Latitude = -33.9249,
            Longitude = 18.4241,
            IsActive = true
        },
        new WeatherStation
        {
            Name = "Desert Eye",
            Location = "Sahara Desert, Algeria",
            Latitude = 27.1277,
            Longitude = 2.6831,
            IsActive = false
        },
        new WeatherStation
        {
            Name = "Tundra Base",
            Location = "Svalbard, Norway",
            Latitude = 78.2232,
            Longitude = 15.6267,
            IsActive = true
        }
    ];

    public Task<IEnumerable<WeatherStation>> GetAllAsync()
    {
        return Task.FromResult<IEnumerable<WeatherStation>>(_stations);
    }

    public Task<WeatherStation?> GetByIdAsync(Guid id)
    {
        return Task.FromResult(_stations.FirstOrDefault(s => s.Id == id));
    }
}
