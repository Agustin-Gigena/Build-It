// Bootstrap mínimo: solo punto de entrada para que `dotnet build` sea verde en CI.
// Sin lógica: configuración real (OpenIddict, EF, endpoints) se agrega en la fase de implementación.
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.Run();
