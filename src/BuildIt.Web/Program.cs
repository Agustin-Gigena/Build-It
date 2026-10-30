// Bootstrap mínimo: solo punto de entrada para que `dotnet build` sea verde en CI.
// Sin lógica: configuración real (RCL, render modes, HttpClient) se agrega en la fase de implementación.
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.Run();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
