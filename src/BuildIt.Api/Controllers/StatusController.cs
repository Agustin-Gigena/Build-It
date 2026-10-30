using Microsoft.AspNetCore.Mvc;

namespace BuildIt.Api.Controllers;

[ApiController]
[Route("api/status")]
public sealed class StatusController(IHostEnvironment env) : ControllerBase
{
    [HttpGet]
    public IActionResult Get() => Ok(new
    {
        app = "BuildIt.Api",
        environment = env.EnvironmentName,
        serverTimeUtc = DateTimeOffset.UtcNow
    });
}
