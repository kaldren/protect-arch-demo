using Application.UseCases;
using Domain.Interfaces;
using Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IWeatherRepository, InMemoryWeatherRepository>();
builder.Services.AddTransient<GetWeatherForecastsQuery>();
builder.Services.AddTransient<GetWeatherForecastByIdQuery>();

builder.Services.AddOpenApi();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.MapGet("/weatherforecast", async (GetWeatherForecastsQuery query) =>
{
    var forecasts = await query.ExecuteAsync();
    return Results.Ok(forecasts);
})
.WithName("GetWeatherForecasts");

app.MapGet("/weatherforecast/{id:guid}", async (Guid id, GetWeatherForecastByIdQuery query) =>
{
    var forecast = await query.ExecuteAsync(id);
    return forecast is not null ? Results.Ok(forecast) : Results.NotFound();
})
.WithName("GetWeatherForecastById");

app.Run();
