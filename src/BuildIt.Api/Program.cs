// Bootstrap mínimo: solo punto de entrada para que `dotnet build` sea verde en CI.
// Sin lógica: configuración real (OpenIddict, EF, endpoints) se agrega en la fase de implementación.
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
// Marcador provisional de scaffold: se reemplaza por los Endpoints reales.
app.MapGet("/", () => "BuildIt.Api — scaffold OK");
app.Run();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
