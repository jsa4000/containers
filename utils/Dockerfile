FROM docker.io/library/alpine:3.20

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

LABEL org.opencontainers.image.description "Container Image with command line utils."