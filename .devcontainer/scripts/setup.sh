#!/usr/bin/env bash
# =============================================================================
# setup.sh — aprovisionamiento del contenedor de desarrollo (postCreateCommand)
# =============================================================================
# Corre UNA VEZ por creación del contenedor (devcontainer CLI / VS Code),
# dentro del contenedor, como el usuario del host, después de que las features
# (node, apt packages) estén instaladas.
#
# Falla rápido: cada paso está encadenado con && — si algo falla, el postCreate
# se marca con error a la vista (decisión deliberada: sin `|| true` que oculte).
#
# Pasos:
#   1. git safe.directory — el bind mount del repo es del uid del host; sin esto
#      git lo rechaza por "dubious ownership".
#   2. gh auth setup-git — git usa gh como credential helper para push/pull
#      (la sesión de gh se hereda del host por el mount de ~/.config/gh).
#   3. dotnet dev-certs https — cert de desarrollo para el puerto HTTPS (8081).
#   4. dotnet restore — paquetes NuGet (cache persistente en el volumen
#      `nuget-packages`; después de un rebuild no re-descarga). dotnet-ef lo instala
#      el feature `dotnet-tools` (ver devcontainer.json).
#   5. mkdir /tmp/msbuild-debug — destino de MSBuild_*.failure.txt cuando un
#      nodo de MSBuild muere (el task "build" define MSBUILDDEBUGPATH apuntando ahí).
#   6. agent-browser + Chromium — CLI de automatización de navegador para probar
#      la UI sin salir del contenedor. `--allow-scripts=agent-browser` habilita su
#      postinstall (npm 11 bloquea scripts por defecto); `--with-deps` instala las
#      librerías de sistema de Chromium vía apt (usa sudo, disponible sin password).
#   7. playwright install chromium — navegador para el MCP de Playwright (.mcp.json),
#      alternativa/ complemento de agent-browser en pruebas de UI.
# =============================================================================
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

paso() { echo "==> $1"; }

paso "git: marcando /Build_it como directorio seguro"
git config --global --add safe.directory /Build_it

paso "gh: configurando credential helper de git"
gh auth setup-git

paso "dotnet: certificado de desarrollo HTTPS"
dotnet dev-certs https

paso "dotnet: restaurando paquetes (dotnet-ef lo instala el feature dotnet-tools)"
dotnet restore

paso "msbuild: creando directorio de diagnóstico /tmp/msbuild-debug"
mkdir -p /tmp/msbuild-debug

paso "agent-browser: instalando CLI global (npm)"
npm install -g --allow-scripts=agent-browser agent-browser

paso "agent-browser: instalando Chromium y dependencias de sistema"
agent-browser install --with-deps

paso "playwright: instalando Chromium para el MCP de Playwright"
npx -y playwright@latest install chromium

echo "setup completado ✓"
