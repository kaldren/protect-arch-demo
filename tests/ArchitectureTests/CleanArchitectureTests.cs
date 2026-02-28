using System.Reflection;
using NetArchTest.Rules;

namespace ArchitectureTests;

public class CleanArchitectureTests
{
    private static readonly Assembly DomainAssembly = typeof(Domain.Entities.WeatherForecast).Assembly;
    private static readonly Assembly ApplicationAssembly = typeof(Application.UseCases.GetWeatherForecastsQuery).Assembly;
    private static readonly Assembly InfrastructureAssembly = typeof(Infrastructure.Repositories.InMemoryWeatherRepository).Assembly;

    [Fact]
    public void Domain_Should_Not_Depend_On_Application()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn("Application")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Domain must not depend on Application. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Domain_Should_Not_Depend_On_Infrastructure()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn("Infrastructure")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Domain must not depend on Infrastructure. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Domain_Should_Not_Depend_On_Api()
    {
        var result = Types.InAssembly(DomainAssembly)
            .ShouldNot()
            .HaveDependencyOn("Api")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Domain must not depend on Api. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Application_Should_Not_Depend_On_Infrastructure()
    {
        var result = Types.InAssembly(ApplicationAssembly)
            .ShouldNot()
            .HaveDependencyOn("Infrastructure")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Application must not depend on Infrastructure. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Application_Should_Not_Depend_On_Api()
    {
        var result = Types.InAssembly(ApplicationAssembly)
            .ShouldNot()
            .HaveDependencyOn("Api")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Application must not depend on Api. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Infrastructure_Should_Not_Depend_On_Api()
    {
        var result = Types.InAssembly(InfrastructureAssembly)
            .ShouldNot()
            .HaveDependencyOn("Api")
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Infrastructure must not depend on Api. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }

    [Fact]
    public void Domain_Interfaces_Should_Not_Have_Implementations()
    {
        var result = Types.InAssembly(DomainAssembly)
            .That()
            .ResideInNamespace("Domain.Interfaces")
            .Should()
            .BeInterfaces()
            .GetResult();

        Assert.True(result.IsSuccessful,
            "Domain.Interfaces namespace should only contain interfaces. " +
            "Violating types: " + string.Join(", ", result.FailingTypeNames ?? []));
    }
}
