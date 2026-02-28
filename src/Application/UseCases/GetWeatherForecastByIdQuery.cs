using Domain.Entities;
using Domain.Interfaces;

namespace Application.UseCases;

public class GetWeatherForecastByIdQuery
{
    private readonly IWeatherRepository _repository;

    public GetWeatherForecastByIdQuery(IWeatherRepository repository)
    {
        _repository = repository;
    }

    public async Task<WeatherForecast?> ExecuteAsync(Guid id)
    {
        return await _repository.GetByIdAsync(id);
    }
}
