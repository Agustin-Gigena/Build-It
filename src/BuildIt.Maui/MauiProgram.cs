using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Http;
using Microsoft.Maui.Storage;

namespace BuildIt.Maui;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        // appsettings.json embebido (Api:BaseUrl = 10.0.2.2 desde el emulador Android)
        var config = new ConfigurationManager();
        using var stream = FileSystem.OpenAppPackageFileAsync("appsettings.json").GetAwaiter().GetResult();
        config.AddJsonStream(stream);

        var builder = MauiApp.CreateBuilder();
        builder.UseMauiApp<App>();

        builder.Services.AddMauiBlazorWebView();
#if DEBUG
        builder.Services.AddBlazorWebViewDeveloperTools();
#endif

        builder.Services.AddSingleton<IConfiguration>(config);

        // HttpClient hacia la Api con pipeline resiliente (retry/circuit breaker/timeout)
        builder.Services
            .AddHttpClient("Api", client => client.BaseAddress = new Uri(config["Api:BaseUrl"]!))
            .AddStandardResilienceHandler();
        builder.Services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("Api"));

        return builder.Build();
    }
}
