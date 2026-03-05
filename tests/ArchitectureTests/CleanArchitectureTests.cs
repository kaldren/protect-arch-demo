using ArchUnitNET.Domain;
using ArchUnitNET.Loader;
using ArchUnitNET.Fluent;
using ArchUnitNET.xUnit;
using static ArchUnitNET.Fluent.ArchRuleDefinition;

namespace ArchitectureTests;

public class CleanArchitectureTests
{
    private static readonly System.Reflection.Assembly DomainAssembly = typeof(Domain.Entities.WeatherForecast).Assembly;
    private static readonly System.Reflection.Assembly ApplicationAssembly = typeof(Application.UseCases.GetWeatherForecastsQuery).Assembly;
    private static readonly System.Reflection.Assembly InfrastructureAssembly = typeof(Infrastructure.Repositories.InMemoryWeatherRepository).Assembly;

    private static readonly Architecture Architecture = new ArchLoader()
        .LoadAssemblies(DomainAssembly, ApplicationAssembly, InfrastructureAssembly)
        .Build();

    private readonly IObjectProvider<IType> DomainLayer =
        Types().That().ResideInAssembly(DomainAssembly).As("Domain Layer");

    private readonly IObjectProvider<IType> ApplicationLayer =
        Types().That().ResideInAssembly(ApplicationAssembly).As("Application Layer");

    private readonly IObjectProvider<IType> InfrastructureLayer =
        Types().That().ResideInAssembly(InfrastructureAssembly).As("Infrastructure Layer");

    [Fact]
    public void Domain_Should_Not_Depend_On_Application()
    {
        Types().That().Are(DomainLayer)
            .Should().NotDependOnAny(ApplicationLayer)
            .Because("Domain must not depend on Application")
            .Check(Architecture);
    }

    [Fact]
    public void Domain_Should_Not_Depend_On_Infrastructure()
    {
        Types().That().Are(DomainLayer)
            .Should().NotDependOnAny(InfrastructureLayer)
            .Because("Domain must not depend on Infrastructure")
            .Check(Architecture);
    }

    [Fact]
    public void Domain_Should_Not_Depend_On_Api()
    {
        Types().That().Are(DomainLayer)
            .Should().NotDependOnAnyTypesThat().ResideInNamespace("Api")
            .Because("Domain must not depend on Api")
            .Check(Architecture);
    }

    [Fact]
    public void Application_Should_Not_Depend_On_Infrastructure()
    {
        Types().That().Are(ApplicationLayer)
            .Should().NotDependOnAny(InfrastructureLayer)
            .Because("Application must not depend on Infrastructure")
            .Check(Architecture);
    }

    [Fact]
    public void Application_Should_Not_Depend_On_Api()
    {
        Types().That().Are(ApplicationLayer)
            .Should().NotDependOnAnyTypesThat().ResideInNamespace("Api")
            .Because("Application must not depend on Api")
            .Check(Architecture);
    }

    [Fact]
    public void Infrastructure_Should_Not_Depend_On_Api()
    {
        Types().That().Are(InfrastructureLayer)
            .Should().NotDependOnAnyTypesThat().ResideInNamespace("Api")
            .Because("Infrastructure must not depend on Api")
            .Check(Architecture);
    }

    [Fact]
    public void Domain_Interfaces_Should_Only_Be_Interfaces()
    {
        Classes().That().ResideInNamespace("Domain.Interfaces")
            .Should().NotExist()
            .Because("Domain.Interfaces namespace should only contain interfaces, not classes")
            .Check(Architecture);
    }
}
