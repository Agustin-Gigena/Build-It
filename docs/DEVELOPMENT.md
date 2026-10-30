# Flujo de desarrollo — BuildIt

Congelado en `feat/arquitectura-monorepo`. Stack: .NET 10 · OpenIddict 7.7.2 · EF Core 10 · MySQL 8.4 · xUnit v2 (VSTest) · Testcontainers.

## Ramas y releases

| Rama / ref | Rol | Reglas |
|---|---|---|
| `production` | trunk desplegable | protegida: solo PRs (squash), CI verde obligatorio |
| `feat/*`, `fix/*`, `chore/*` | trabajo diario | nacen de `production`, vida corta (< 3 días) |
| `v*` (tags) | releases | dispara publicación de imágenes GHCR (Api/Web) |

```mermaid
gitGraph
  commit id: "base"
  branch feat/x
  commit id: "trabajo"
  checkout production
  merge feat/x id: "PR squash (CI verde)"
  commit tag: "v1.0.0" type: HIGHLIGHT
```

## Puertas de calidad (CI: `.github/workflows/ci.yml`)

> **API (decisión)**: controladores MVC, no minimal APIs → `src/BuildIt.Api/Controllers/`.
> Surface actual: `GET /api/status` · `GET /health/live` · `GET /openapi/v1.json`.
> **MAUI**: `MauiProgram` lee el `appsettings.json` embebido y registra el HttpClient
> `Api` (BaseAddress `Api:BaseUrl`, 10.0.2.2 en emulador) con `AddStandardResilienceHandler()`;
> `Home.razor` (shell mínimo del proyecto Maui) consume `GET /api/status`.

1. Build con `TreatWarningsAsErrors` (global, `Directory.Build.props`).
2. `dotnet test` de los 4 proyectos de test con cobertura (`tests/coverlet.runsettings`).
3. `dotnet format --verify-no-changes` sobre `BuildIt.slnf` (solución sin Maui) en CI. Hooks lefthook: solo testeo unit mínimo en pre-push (instantáneo).
4. Cobertura: subir umbral a 60% líneas en `coverlet.runsettings` al mergear los primeros tests reales (hoy está comentado: cero tests romperían la puerta).
5. `NuGetAudit` con `TreatWarningsAsErrors`: los transitivos con CVE se pinnearon en `Directory.Packages.props` (Pkcs/Xml 10.0.14); ante un NU1903 nuevo → pin parcheado, nunca suprimir.
6. Build Android (`maui-android`) solo en push a `production` (workload costoso para cada PR).

## Comandos locales

```bash
dotnet build src/BuildIt.Api          # un proyecto por invocación (limitación CLI)
dotnet test tests/BuildIt.Api.Tests --settings tests/coverlet.runsettings
dotnet format                         # antes de commitear (o deja que lefthook lo verifique)
lefthook install                      # activa los hooks (ya ejecutado en este repo)
```

## Ejecución local (VS Code: `.vscode/tasks.json` + `launch.json`)

> **Bind `0.0.0.0` en dev**: Kestrel en `localhost` solo escucha el loopback del
> contenedor y el port-forwarding de VS Code llega por la interfaz del contenedor →
> desde fuera "no responde" (verificado: `curl <ip-contenedor>` da `000` con bind
> `localhost`). Producción fija su propio `ASPNETCORE_URLS`; estos perfiles son
> solo Development.

| Modo | Sin debugger (tasks) | Con debugger (F5) | URLs |
|---|---|---|---|
| **API + WEB** | task `🔁 MODO: API + WEB (watch)` (dotnet watch x2) | compound `▶ API + WEB` (`coreclr`, build previo incluido) | Api http://localhost:8080 · Web http://localhost:5000 |
| **API + MAUI** | task `🔁 MODO: API + MAUI (watch)` (Api en watch + deploy Android) | compound `▶ API + MAUI (Android)` — Api en `coreclr` + Maui en `dotnet` | Api http://localhost:8080 · app en emulador/dispositivo |

Notas de modo MAUI:
- El `appsettings.json` de `BuildIt.Maui` apunta a `http://10.0.2.2:8080` (loopback del host visto por el emulador Android). Dispositivo físico por USB/LAN: reemplazar por la IP LAN (vía `usbipd-win` en WSL2 + `adb`).
- Requiere workload `maui-android` y emulador activo o dispositivo conectado (`adb devices`).
  ⚠️ El workload vive en la capa de imagen del contenedor: tras un rebuild del devcontainer
  hay que reinstalarlo (`sudo dotnet workload install maui-android`). Considerar hornearlo
  en el Dockerfile/feature para eliminar el paso manual.
- **Debug con breakpoints de la app MAUI en Android**: requiere C# Dev Kit (tipo `dotnet` en launch.json) + extensión .NET MAUI. Sin Dev Kit, el modo soportado es la task `run: maui (android)` (deploy + launch sin debugger). Los configs de Api/Web usan `coreclr` (C# extension): no leen `launchSettings.json`, por eso fijan `ASPNETCORE_URLS` explícito.

## Matriz de tests

| Nivel | Proyecto | Herramientas | Qué cubre | Cuándo corre |
|---|---|---|---|---|
| Unit | `tests/BuildIt.Shared.Tests` | xUnit v2 puro | dominio, DTOs, validaciones | pre-push + CI |
| Unit | `tests/BuildIt.Api.Tests` (raíz) | xUnit v2 | servicios, lógica de endpoints | pre-push + CI |
| Integración | `tests/BuildIt.Api.Tests/Integration/` | `WebApplicationFactory` + `Testcontainers.MySql` (imagen propia `build-it-db`) | EF migraciones, `/connect/token` de OpenIddict (client_credentials/password), endpoints con BD real | **solo CI** — ubuntu tiene Docker; SIEMPRE con `[Trait("Category", "Integration")]` (el pre-push filtra `Category!=Integration`) |
| Unit + host | `tests/BuildIt.Web.Tests` (raíz + `Integration/`) | xUnit v2 + `WebApplicationFactory<Program>` | host Blazor: rutas, SSR, estado de páginas | pre-push + CI |
| Componente | `tests/BuildIt.SharedUI.Tests` | bUnit 2.13 + xUnit v2 | componentes .razor de la RCL + ViewModels (**superficie testeable de Maui**) | pre-push + CI |
| E2E (futuro) | `tests/BuildIt.Web.E2E` / dispositivo | Playwright / Appium-XHarness | flujos críticos Web; flujos on-device de Maui | nocturno / pre-release |

**MAUI y tests**: `BuildIt.Maui` no tendrá proyecto de test unitario propio — sus TFMs (`net10.0-android/ios/maccatalyst`) no son referenciables desde `net10.0`. El contrato congelado: toda su lógica (ViewModels, servicios de UI) vive en `BuildIt.SharedUI` y se testea en `SharedUI.Tests`; el glue de plataforma (`MauiProgram`, `MainPage`, APIs nativas) se mantiene fino detrás de interfaces declaradas en `BuildIt.Shared` (testeables con fakes) y se verifica en la fase E2E de dispositivo.

Reglas: sin tests que toquen red/BD real fuera de `Integration/`; los tests de integración no asumen estado previo; todo bug corregido entra con test de regresión failing-before/passing-after.

## Resiliencia (paquetes ya referenciados; wiring al implementar)

| Capa | Mecanismo | Paquete / medio | Configuración |
|---|---|---|---|
| HTTP saliente (Web/Maui → Api, Api → externos) | retry exp. + jitter, circuit breaker, timeout por intento y total, rate limiter | `Microsoft.Extensions.Http.Resilience` (pipeline estándar v10) | `AddStandardResilienceHandler()` sobre el typed client |
| BD | reintentos transitorios (pérdida conexión, deadlocks) | estrategia de ejecución del proveedor (`EnableRetryOnFailure`) | registro del `DbContext` en Api |
| Salud | liveness/ready con chequeo de BD | HealthChecks (`AddDbContextCheck`) | endpoints `/health/live` (sin BD) y `/health/ready` (con BD) en Api |
| Edge | rate limiting por IP + timeouts de request | middleware inbox de ASP.NET Core | `Program.cs` de Api |
| Contratos | errores uniformes | `ProblemDetails` | `AddProblemDetails()` |
| UI Blazor | aislamiento de fallos de render | `ErrorBoundary` por página | SharedUI/Web |
| Tokens | refresh + skew tolerado | OpenIddict + clientes | Web/Maui al implementar auth |

Observabilidad (siguiente fase, no referenciado aún): OpenTelemetry (logs/traces/metrics) — decisión de backend (OTLP collector) pendiente.

## Escalabilidad

- **Proceso**: versiones centralizadas (CPM) — agregar proyecto = 1 csproj + 1 línea en `BuildIt.slnx`; CI por proyecto explícito (paralelizable a matrix si crece); `dotnet test --filter` y sharding cuando la suite supere ~5 min.
- **App**: Api stateless (tokens OpenIddict, sesión en BD/Redis futuro) → escalar horizontal; Blazor Web preferir SSR estático + islas de interactividad (evita backplane de SignalR); cache con `HybridCache` cuando haya lecturas calientes; migraciones siempre hacia adelante, aplicadas por pipeline, nunca en startup de producción.

## Definition of Done (por PR)

CI verde (build + tests + formato) · migraciones revisadas · resiliencia/errores cubiertos para nuevos flujos · sin `.gitkeep` huérfanos · docs actualizadas si cambia el flujo.
