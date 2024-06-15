FROM docker.io/library/alpine:3.20

ENV VERSION=alpine-3.20

LABEL maintainer="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.authors="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.url="https://github.com/jsa4000/containers.git" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="Apache License" \
      org.opencontainers.image.title="OpenTofu ToolBox" \
      org.opencontainers.image.description="Container image with OpenTofu and useful linux tools"

ARG TARGETPLATFORM

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

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
