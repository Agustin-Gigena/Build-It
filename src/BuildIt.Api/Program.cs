var builder = WebApplication.CreateBuilder(args);

// Controladores (decisión: MVC, no minimal APIs)
builder.Services.AddControllers();
// Documento OpenAPI en /openapi/v1.json
builder.Services.AddOpenApi();
// /health/live — el check de BD se suma con el wiring de EF
builder.Services.AddHealthChecks();

var app = builder.Build();

app.MapOpenApi();
app.MapHealthChecks("/health/live");
app.MapControllers();

app.Run();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
