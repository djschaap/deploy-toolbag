FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

# Available kubectl Releases: https://dl.k8s.io/release
ARG  \
    ARCH=amd64 \
    KUBECTL_VERSION=1.25.14

RUN \
    apk add --no-cache \
        jq \
        make \
        vault \
    && curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" \
        -o /usr/local/bin/kubectl \
    && chmod 0755 /usr/local/bin/kubectl \
    && gcloud components install --quiet \
        gke-gcloud-auth-plugin \
        kustomize \
    && rm -rf /google-cloud-sdk/.install/.backup \
    && find /google-cloud-sdk -name __pycache__ | xargs rm -rf \
    && gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud --version \
    && rm -rf -- /root/.config/gcloud/logs/*

RUN \
    HADOLINT_VARIANT="$(uname -s)-$(uname -m)" \
    && curl -fsSL https://api.github.com/repos/hadolint/hadolint/releases/latest \
        | jq ".assets[] | select(.name==\"hadolint-${HADOLINT_VARIANT}\") | .browser_download_url" \
        | xargs curl -fsSo /usr/local/bin/hadolint -L \
    && chmod 0755 /usr/local/bin/hadolint \
    && curl -fsSL https://api.github.com/repos/instrumenta/kubeval/releases/latest \
        | jq ".assets[] | select(.name==\"kubeval-linux-${ARCH}.tar.gz\") | .browser_download_url" \
        | xargs curl -fsSL \
        | tar xzoC /usr/local/bin kubeval

USER cloudsdk
