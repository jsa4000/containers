# renovate: datasource=docker depName=caddy
ARG CADDY_VERSION=2.11.3
# renovate: datasource=github-releases depName=caddy-dns/cloudflare
ARG CADDY_DNS_CLOUDFLARE_VERSION=v0.2.4

FROM caddy:${CADDY_VERSION}-builder AS builder

ARG CADDY_VERSION
ARG CADDY_DNS_CLOUDFLARE_VERSION

RUN xcaddy build v${CADDY_VERSION} \
    --with github.com/caddy-dns/cloudflare@${CADDY_DNS_CLOUDFLARE_VERSION} \
    --with github.com/mholt/caddy-ratelimit@b8d8c9a9d99ee352d675cbbe416ec2b489fc8cab

FROM caddy:${CADDY_VERSION}-alpine

LABEL maintainer="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.authors="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.url="https://github.com/jsa4000/containers.git" \
      org.opencontainers.image.licenses="Apache License" \
      org.opencontainers.image.title="caddy" \
      org.opencontainers.image.description="Container image for caddy"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
