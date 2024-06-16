FROM docker.io/library/alpine:3.20

LABEL maintainer="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.authors="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.url="https://github.com/jsa4000/containers.git" \
      org.opencontainers.image.licenses="Apache License" \
      org.opencontainers.image.title="OpenTofu" \
      org.opencontainers.image.description="Container image with OpenTofu and a variety of linux tools"

ARG TARGETPLATFORM
ENV OPENTOFU_VERSION=1.7.2

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        kubectl \
        git \
        jo \
        jq \
        catatonit \
        moreutils \
        unzip \
        wget \
        zip

#hadolint ignore=DL3018
RUN \
    curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    bash ./install-opentofu.sh --skip-verify --install-method standalone --opentofu-version"${OPENTOFU_VERSION}" && \
    rm install-opentofu.sh
    
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
