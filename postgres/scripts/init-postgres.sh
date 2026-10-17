#!/bin/bash
set -e;
set -u

function create_user_and_database() {
    local database=$1
    echo "  Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
        CREATE DATABASE $database owner $database;
EOSQL
    # As the superuser: `vector` is not a trusted extension, so the database owner cannot create it.
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$database" <<-EOSQL
        CREATE EXTENSION IF NOT EXISTS vector;
        CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
EOSQL
}

if [ -n "${POSTGRES_MULTIPLE_DATABASES:-}" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done
    echo "Multiple databases created"
fi
