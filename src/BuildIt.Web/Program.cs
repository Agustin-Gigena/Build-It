using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<BuildIt.SharedUI.App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

// HttpClient hacia la Api con dirección base desde appsettings.json (Api:BaseUrl).
// En desarrollo: http://localhost:8080 (la Api).
var baseUrl = builder.Configuration["Api:BaseUrl"] ?? builder.HostEnvironment.BaseAddress;
builder.Services.AddScoped(sp => new HttpClient
{
    BaseAddress = new Uri(baseUrl)
});

await builder.Build().RunAsync();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
