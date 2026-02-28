using Domain.Entities;
using Domain.Interfaces;

namespace Application.UseCases;

public class GetWeatherForecastsQuery
{
    private readonly IWeatherRepository _repository;

    public GetWeatherForecastsQuery(IWeatherRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<WeatherForecast>> ExecuteAsync()
    {
        return await _repository.GetForecastsAsync();
    }
}
