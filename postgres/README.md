# postgres

[PostgreSQL](https://www.postgresql.org/) image built on top of the official
`postgres:*` image, extended with [pgvector](https://github.com/pgvector/pgvector)
installed from the PGDG apt repository the official image already configures.
Staying on the official image keeps Postgres updates on the upstream release
cadence and the same Debian base as the data volume.

It also bundles an init script that creates one user and database per entry in
`POSTGRES_MULTIPLE_DATABASES`, so a single instance can serve several services.

## Included extensions

| Extension                                                        | Purpose                                |
| ---------------------------------------------------------------- | -------------------------------------- |
| [`vector`](https://github.com/pgvector/pgvector)                 | Vector similarity search (embeddings)  |
| [`pg_trgm`](https://www.postgresql.org/docs/current/pgtrgm.html) | Trigram matching for fuzzy text search |

Both extensions are created automatically in every database listed in
`POSTGRES_MULTIPLE_DATABASES`. For other databases run
`CREATE EXTENSION vector;` as a superuser (`vector` is not a trusted extension).

## Build

```bash
# Build the image (Postgres version is the FROM tag in the Dockerfile)
docker build -t postgres .

# Or using the repository task
task container:build:postgres
```

Multi-architecture build using `buildx`:

```bash
# Create a multi-platform builder (only needed once)
docker buildx create --use --platform=linux/amd64,linux/arm64 --name multi-platform-builder

# Build for multiple architectures
docker buildx build --platform linux/amd64,linux/arm64 -t postgres .
```

## Run with Docker

```bash
docker run -d \
  --name postgres \
  --restart unless-stopped \
  -p 127.0.0.1:5432:5432 \
  -v postgres_storage:/var/lib/postgresql \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=changeme \
  -e POSTGRES_MULTIPLE_DATABASES=app1,app2 \
  -e PGUSER=postgres \
  ghcr.io/jsa4000/postgres:latest
```

Check the extensions are available:

```bash
docker exec postgres psql -d app1 -c '\dx'
```

> The init scripts only run when the data directory is empty (first start).
> Adding a database to `POSTGRES_MULTIPLE_DATABASES` later requires creating it
> manually or recreating the volume.

## Environment variables

All [official image variables](https://hub.docker.com/_/postgres) are supported. The most relevant ones:

| Variable                      | Default    | Description                                                                                                         |
| ----------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------- |
| `POSTGRES_USER`               | `postgres` | Superuser name                                                                                                      |
| `POSTGRES_PASSWORD`           | —          | Superuser password (required)                                                                                       |
| `POSTGRES_MULTIPLE_DATABASES` | —          | Comma-separated list. Each entry creates a user and database with that name, owned by it, using `POSTGRES_PASSWORD` |
| `PGUSER`                      | —          | Default user for client tools such as `pg_isready` (set it to `POSTGRES_USER`)                                      |
| `TZ`                          | `UTC`      | Container timezone                                                                                                  |

## Volumes

| Path                          | Description                                                                                            |
| ----------------------------- | ------------------------------------------------------------------------------------------------------ |
| `/var/lib/postgresql`         | Data directory (Postgres 18+ stores data in a versioned subdirectory) — **persist it**                 |
| `/docker-entrypoint-initdb.d` | Init scripts. The bundled one is `10-init-databases.sh`; mount extra `*.sh`/`*.sql` files alongside it |

## Docker Compose

```yaml
services:
    postgres:
        image: ghcr.io/jsa4000/postgres:18.6
        restart: unless-stopped
        environment:
            POSTGRES_USER: ${DB_ROOT_USER}
            POSTGRES_PASSWORD: ${DB_ROOT_PASSWORD}
            POSTGRES_MULTIPLE_DATABASES: ${DB_DATABASES}
            # Needed for the 'pg_isready' healthcheck
            PGUSER: ${DB_ROOT_USER}
            TZ: ${TZ:-UTC}
        ports:
            - "${SERVICE_BIND_ADDRESS:-127.0.0.1}:${DB_PORT:-5432}:5432"
        volumes:
            - postgres_storage:/var/lib/postgresql
        healthcheck:
            # -h forces a TCP check against the real server; without it pg_isready
            # hits the Unix socket, which the initdb bootstrap instance also
            # accepts before docker-entrypoint-initdb.d scripts have finished.
            test: ["CMD-SHELL", "pg_isready -h 127.0.0.1 -U ${DB_ROOT_USER}"]
            interval: 5s
            timeout: 5s
            retries: 10
            start_period: 30s
        networks:
            - shared_network

networks:
    shared_network:
        name: ${NETWORK_NAME}
        external: true

volumes:
    postgres_storage:
```

## Upgrades

Minor/patch upgrades (e.g. `18.6` → `18.7`) are drop-in. Major upgrades
(e.g. `18` → `19`) are not: the data directory must be migrated with
`pg_upgrade` or a dump/restore. Renovate is configured to skip major bumps for
this image.
