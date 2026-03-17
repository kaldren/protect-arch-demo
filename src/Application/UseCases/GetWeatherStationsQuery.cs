using Domain.Entities;
using Domain.Interfaces;

namespace Application.UseCases;

public class GetWeatherStationsQuery
{
    private readonly IWeatherStationRepository _repository;

    public GetWeatherStationsQuery(IWeatherStationRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<WeatherStation>> ExecuteAsync()
    {
        return await _repository.GetAllAsync();
    }
}
