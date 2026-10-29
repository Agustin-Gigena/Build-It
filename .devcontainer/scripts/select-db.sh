#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

branch="$(git branch --show-current)"
case "$branch" in
  production|development|release_candidate) ;;
  *)
    echo "ERROR: rama no soportada para la imagen MySQL: ${branch}" >&2
    exit 1
    ;;
esac

: "${BUILD_IT_DOCKER_SOCKET:=}"
if [ -z "$BUILD_IT_DOCKER_SOCKET" ]; then
  case "${DOCKER_HOST:-}" in
    unix://*) BUILD_IT_DOCKER_SOCKET="${DOCKER_HOST#unix://}" ;;
  esac
fi
if [ -z "$BUILD_IT_DOCKER_SOCKET" ]; then
  for s in "/run/user/$(id -u)/podman/podman.sock" /var/run/docker.sock; do
    if [ -S "$s" ]; then BUILD_IT_DOCKER_SOCKET="$s"; break; fi
  done
fi
if [ ! -S "$BUILD_IT_DOCKER_SOCKET" ]; then
  echo "ERROR: no se encontró un socket Unix de contenedores. Revisá DOCKER_HOST (${DOCKER_HOST:-no definido}) o definí BUILD_IT_DOCKER_SOCKET con la ruta del socket." >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1 || ! command -v podman >/dev/null 2>&1; then
  echo "ERROR: se requieren gh y podman en el host para autenticar la descarga de la imagen privada de GHCR." >&2
  exit 1
fi

echo "Autenticando Podman en ghcr.io con la sesión existente de GitHub CLI..."
gh_username="$(gh api user --jq .login)"
mkdir -p "$HOME/.docker"
gh auth token --hostname github.com |
  podman login --compat-auth-file "$HOME/.docker/config.json" \
    --username "$gh_username" --password-stdin ghcr.io

# Directorios que compose bind-monta dentro del contenedor: crearlos ANTES del
# mount para que podman nunca los cree él (si faltan, aparecen con dueño
# incorrecto y VS Code no puede escribirlos).
mkdir -p "$HOME/.omp" "$HOME/.config/gh" "$HOME/.aspnet"

mkdir -p .devcontainer
cat > .devcontainer/.env <<EOF
BUILD_IT_DB_IMAGE=ghcr.io/agustin-gigena/build-it-db-${branch}:latest
BUILD_IT_DOCKER_SOCKET=${BUILD_IT_DOCKER_SOCKET}
BUILD_IT_USER_NAME=$(id -un)
BUILD_IT_USER_GROUP=$(id -gn)
BUILD_IT_USER_UID=$(id -u)
BUILD_IT_USER_GID=$(id -g)
EOF
