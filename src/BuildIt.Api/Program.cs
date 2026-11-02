using Microsoft.AspNetCore.Cors;

var builder = WebApplication.CreateBuilder(args);

// Controladores (decisión: MVC, no minimal APIs)
builder.Services.AddControllers();
// Documento OpenAPI en /openapi/v1.json
builder.Services.AddOpenApi();
// /health/live — el check de BD se suma con el wiring de EF
builder.Services.AddHealthChecks();
// CORS para el frontend Blazor WASM (puerto 5000 en desarrollo).
builder.Services.AddCors(options =>
{
    options.AddPolicy("BlazorWasm", policy =>
    {
        policy.WithOrigins("http://localhost:5000")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

app.MapOpenApi();
app.MapHealthChecks("/health/live");
app.UseCors("BlazorWasm");
app.MapControllers();

app.Run();

// Requerido por WebApplicationFactory<T> en los tests de integración.
public partial class Program { }
