# caddy

[Caddy](https://caddyserver.com/) web server image built on top of the official
`caddy:*-alpine` image, extended with a couple of plugins compiled in via
[`xcaddy`](https://github.com/caddyserver/xcaddy). It keeps Caddy's automatic
HTTPS (ACME) while adding Cloudflare DNS-01 challenge support and request rate
limiting.

## Included plugins

| Plugin                                                              | Purpose                                                              |
| ------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [`caddy-dns/cloudflare`](https://github.com/caddy-dns/cloudflare)   | DNS-01 ACME challenge through Cloudflare (wildcard / internal certs) |
| [`mholt/caddy-ratelimit`](https://github.com/mholt/caddy-ratelimit) | HTTP request rate limiting                                           |

## Build

```bash
# Build the image (Caddy version defaults to the ARG in the Dockerfile)
docker build -t caddy .

# Override the Caddy / plugin versions at build time
docker build \
  --build-arg CADDY_VERSION=2.11.3 \
  --build-arg CADDY_DNS_CLOUDFLARE_VERSION=v0.2.4 \
  -t caddy .
```

Multi-architecture build using `buildx`:

```bash
# Create a multi-platform builder (only needed once)
docker buildx create --use --platform=linux/amd64,linux/arm64 --name multi-platform-builder

# Build for multiple architectures
docker buildx build --platform linux/amd64,linux/arm64 -t caddy .

# Build a single platform (force a fresh build)
docker buildx build --no-cache --platform linux/arm64 -t caddy .
```

## Run with Docker

Caddy is configured through a `Caddyfile` mounted into the container. Mount your
config, persist the `/data` and `/config` directories, publish the HTTP/HTTPS
ports and pass any environment variables referenced by your `Caddyfile`:

```bash
docker run -d \
  --name caddy \
  --restart unless-stopped \
  --cap-add NET_ADMIN \
  -p 80:80 \
  -p 443:443 \
  -p 443:443/udp \
  -v "$(pwd)/config/Caddyfile:/etc/caddy/Caddyfile" \
  -v caddy_storage:/data \
  -v caddy_config:/config \
  -e DOMAIN=example.com \
  -e CLOUDFLARE_API_TOKEN=your-token \
  ghcr.io/jsa4000/caddy:latest
```

> `--cap-add NET_ADMIN` is required for some networking features (e.g. when Caddy
> needs to bind privileged ports or manage low-level networking). The HTTP/3
> endpoint is served over UDP, hence `443:443/udp`.

You can validate or format a `Caddyfile` without starting the server:

```bash
docker run --rm -v "$(pwd)/config/Caddyfile:/etc/caddy/Caddyfile" \
  ghcr.io/jsa4000/caddy:latest caddy validate --config /etc/caddy/Caddyfile

# Confirm the bundled plugins are present
docker run --rm ghcr.io/jsa4000/caddy:latest caddy list-modules | grep -E 'cloudflare|rate_limit'
```

## Environment variables

These variables are consumed by the `Caddyfile` (not the image itself), and match
the values wired up in [`compose.yaml`](./compose.yaml). Reference them in your
config with Caddy's `{env.VAR}` placeholders.

| Variable                | Default | Description                                             |
| ----------------------- | ------- | ------------------------------------------------------- |
| `DOMAIN`                | —       | Primary domain served by Caddy                          |
| `ACME_URL`              | —       | ACME directory URL (leave empty for Let's Encrypt prod) |
| `CLOUDFLARE_API_TOKEN`  | —       | Cloudflare API token used for the DNS-01 challenge      |
| `CLOUDFLARE_EMAIL`      | —       | Cloudflare account email                                |
| `CLOUDFLARE_ZONE_ID`    | —       | Cloudflare zone identifier                              |
| `STORAGE_BUCKET_PUBLIC` | —       | Public storage bucket name                              |
| `STORAGE_S3_SUBDOMAIN`  | `s3`    | Subdomain used to expose the S3-compatible storage      |
| `TZ`                    | `UTC`   | Container timezone                                      |
| `GENERIC_TIMEZONE`      | `UTC`   | Generic timezone passed to the application              |

## Volumes

| Path                   | Description                                                             |
| ---------------------- | ----------------------------------------------------------------------- |
| `/etc/caddy/Caddyfile` | Your Caddy configuration (mount read-only or read-write)                |
| `/data`                | Certificates and ACME state — **must be persisted** to avoid re-issuing |
| `/config`              | Auto-saved JSON config managed by Caddy                                 |

## Docker Compose

A ready-to-use [`compose.yaml`](./compose.yaml) is provided. It runs Caddy under
the `caddy` profile, mounts `./config/Caddyfile`, persists named volumes and
attaches to an external `shared_network`:

```bash
docker compose --profile caddy up
```

The compose file expects a few host-level variables:

| Variable           | Default      | Description                                     |
| ------------------ | ------------ | ----------------------------------------------- |
| `NETWORK_NAME`     | —            | Name of the **external** Docker network to join |
| `VOLUME_BASE_PATH` | `./.volumes` | Base path for the bind-mounted named volumes    |

Create the external network beforehand if it does not exist:

```bash
docker network create "${NETWORK_NAME}"
```
