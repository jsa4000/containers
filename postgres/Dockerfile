# The official Postgres image plus pgvector (`vector`), from the PGDG apt repository the official
# image already configures, instead of a vendor image.
#
# Staying on `postgres:<version>` keeps Postgres updates on the official release cadence and the
# same Debian base as the data volume (so the volume is reusable across rebuilds).
# `PG_MAJOR` comes from the base image, so the FROM tag is the only Postgres version to bump.
FROM postgres:18.6

LABEL maintainer="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.authors="Javier Santos <jsa4000@gmail.com>" \
      org.opencontainers.image.url="https://github.com/jsa4000/containers.git" \
      org.opencontainers.image.licenses="Apache License" \
      org.opencontainers.image.title="postgres" \
      org.opencontainers.image.description="Container image for postgres with pgvector"

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends "postgresql-${PG_MAJOR}-pgvector"; \
  rm -rf /var/lib/apt/lists/*

# Creates one user and database (with `vector` and `pg_trgm`) per entry in
# POSTGRES_MULTIPLE_DATABASES on first start. No-op when the variable is unset.
COPY --chmod=755 scripts/init-postgres.sh /docker-entrypoint-initdb.d/10-init-databases.sh
