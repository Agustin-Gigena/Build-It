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

# Directorios que compose bind-monta dentro del contenedor: crearlos ANTES del
# mount para que podman nunca los cree él (si faltan, aparecen con dueño
# incorrecto y VS Code no puede escribirlos).
mkdir -p "$HOME/.omp" "$HOME/.config/gh" "$HOME/.aspnet"

mkdir -p .devcontainer
cat > .devcontainer/.env <<EOF
BUILD_IT_DB_IMAGE=ghcr.io/agustin-gigena/build-it-db-${branch}:latest
BUILD_IT_DOCKER_SOCKET=${BUILD_IT_DOCKER_SOCKET}
EOF
