FROM mcr.microsoft.com/devcontainers/base:debian-11

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
    HADOLINT_VARIANT="$(uname -s)-(uname -m)" \
    && rm -f /usr/local/bin/hadolint \
    && curl -fsSL https://api.github.com/repos/hadolint/hadolint/releases/latest \
        | jq ".assets[] | select(.name==\"hadolint-${HADOLINT_VARIANT}\") | .browser_download_url" \
        | xargs curl -fsS -o /usr/local/bin/hadolint -L \
    && chmod 0755 /usr/local/bin/hadolint

USER vscode
