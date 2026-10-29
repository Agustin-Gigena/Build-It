#!/usr/bin/env bash
set -euo pipefail

image="${BUILD_IT_DB_IMAGE:-ghcr.io/agustin-gigena/build-it-db}"
source_url="${BUILD_IT_SOURCE_URL:-https://github.com/Agustin-Gigena/Build-It}"
tag="${BUILD_IT_DB_TAG:-latest}"
engine="${BUILD_IT_CONTAINER_ENGINE:-}"
context="$(mktemp -d)"
trap 'rm -rf "$context"' EXIT

if [[ -z "$engine" ]]; then
  if command -v podman >/dev/null 2>&1; then
    engine=podman
  elif command -v docker >/dev/null 2>&1; then
    engine=docker
  else
    echo "ERROR: se requiere Podman o Docker para construir la imagen" >&2
    exit 1
  fi
fi

cat > "$context/Dockerfile" <<'DOCKERFILE'
FROM mysql:8.4 AS upstream

FROM scratch
COPY --from=upstream / /
COPY mysql.cnf /etc/mysql/conf.d/zz-build-it.cnf
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
DOCKERFILE

cat > "$context/mysql.cnf" <<'MYSQLCONF'
[mysqld]
datadir=/data/mysql
MYSQLCONF

if [[ "$engine" == podman ]]; then
  podman build \
    --pull=always \
    --label "org.opencontainers.image.source=${source_url}" \
    --tag "${image}:${tag}" \
    --tag "${image}:mysql-8.4" \
    "$context"
  podman push "${image}:${tag}"
  podman push "${image}:mysql-8.4"
elif [[ "$engine" == docker ]]; then
  docker buildx build \
    --pull \
    --push \
    --label "org.opencontainers.image.source=${source_url}" \
    --tag "${image}:${tag}" \
    --tag "${image}:mysql-8.4" \
    "$context"
else
  echo "ERROR: motor no soportado: ${engine} (usa podman o docker)" >&2
  exit 1
fi
