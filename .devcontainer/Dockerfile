FROM mcr.microsoft.com/devcontainers/dotnet:dev-10.0-noble

ARG LOCAL_USER
ARG LOCAL_GROUP
ARG LOCAL_UID
ARG LOCAL_GID

RUN set -eu; \
    test -n "${LOCAL_USER}" && test -n "${LOCAL_GROUP}" \
        && test -n "${LOCAL_UID}" && test -n "${LOCAL_GID}"; \
    test "${LOCAL_UID}" -ne 0; \
    if getent passwd "${LOCAL_USER}" >/dev/null; then \
        userdel --remove "${LOCAL_USER}"; \
    fi; \
    uid_user="$(getent passwd "${LOCAL_UID}" | cut -d: -f1 || true)"; \
    if [ -n "${uid_user}" ]; then \
        userdel --remove "${uid_user}"; \
    fi; \
    gid_group="$(getent group "${LOCAL_GID}" | cut -d: -f1 || true)"; \
    named_group_gid="$(getent group "${LOCAL_GROUP}" | cut -d: -f3 || true)"; \
    if [ -n "${gid_group}" ] && [ "${gid_group}" != "${LOCAL_GROUP}" ]; then \
        if [ -n "${named_group_gid}" ] && [ "${named_group_gid}" != "${LOCAL_GID}" ]; then \
            echo "Host group name ${LOCAL_GROUP} already exists with GID ${named_group_gid}" >&2; \
            exit 1; \
        fi; \
        groupmod --new-name "${LOCAL_GROUP}" "${gid_group}"; \
    elif [ -z "${gid_group}" ] && [ -n "${named_group_gid}" ]; then \
        groupmod --gid "${LOCAL_GID}" "${LOCAL_GROUP}"; \
    elif [ -z "${gid_group}" ]; then \
        groupadd --gid "${LOCAL_GID}" "${LOCAL_GROUP}"; \
    fi; \
    useradd --uid "${LOCAL_UID}" --gid "${LOCAL_GID}" --create-home --shell /bin/bash "${LOCAL_USER}"
