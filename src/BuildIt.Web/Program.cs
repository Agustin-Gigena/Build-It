// Bootstrap mínimo: solo punto de entrada para que `dotnet build` sea verde en CI.
// Sin lógica: configuración real (RCL, render modes, HttpClient) se agrega en la fase de implementación.
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
// Marcador provisional de scaffold: se reemplaza por MapRazorComponents/Blazor.
app.MapGet("/", () => "BuildIt.Web — scaffold OK");
app.Run();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
