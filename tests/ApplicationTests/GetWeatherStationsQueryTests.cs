using Application.UseCases;
using Domain.Entities;
using Domain.Interfaces;

namespace ApplicationTests;

public class GetWeatherStationsQueryTests
{
    [Fact]
    public async Task ExecuteAsync_ReturnsAllStationsFromRepository()
    {
        // Arrange
        var expectedStations = new List<WeatherStation>
        {
            new() { Name = "Station A", Location = "Location A", Latitude = 10.0, Longitude = 20.0, IsActive = true },
            new() { Name = "Station B", Location = "Location B", Latitude = 30.0, Longitude = 40.0, IsActive = false }
        };

        var repository = new StubWeatherStationRepository(expectedStations);
        var query = new GetWeatherStationsQuery(repository);

        // Act
        var result = await query.ExecuteAsync();

        // Assert
        var stations = result.ToList();
        Assert.Equal(2, stations.Count);
        Assert.Equal("Station A", stations[0].Name);
        Assert.Equal("Station B", stations[1].Name);
    }

    [Fact]
    public async Task ExecuteAsync_WhenRepositoryIsEmpty_ReturnsEmptyCollection()
    {
        // Arrange
        var repository = new StubWeatherStationRepository([]);
        var query = new GetWeatherStationsQuery(repository);

        // Act
        var result = await query.ExecuteAsync();

        // Assert
        Assert.Empty(result);
    }

    [Fact]
    public async Task ExecuteAsync_DelegatesToRepository()
    {
        // Arrange
        var repository = new StubWeatherStationRepository([]);
        var query = new GetWeatherStationsQuery(repository);

        // Act
        await query.ExecuteAsync();

        // Assert
        Assert.True(repository.GetAllAsyncCalled, "Expected ExecuteAsync to delegate to IWeatherStationRepository.GetAllAsync");
    }

    private sealed class StubWeatherStationRepository : IWeatherStationRepository
    {
        private readonly List<WeatherStation> _stations;
        public bool GetAllAsyncCalled { get; private set; }

        public StubWeatherStationRepository(List<WeatherStation> stations)
        {
            _stations = stations;
        }

        public Task<IEnumerable<WeatherStation>> GetAllAsync()
        {
            GetAllAsyncCalled = true;
            return Task.FromResult<IEnumerable<WeatherStation>>(_stations);
        }

        public Task<WeatherStation?> GetByIdAsync(Guid id)
        {
            return Task.FromResult(_stations.FirstOrDefault(s => s.Id == id));
        }
    }
}
