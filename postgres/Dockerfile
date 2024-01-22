FROM postgres:11.5


# Set environment variables for PostgreSQL
ENV POSTGRES_DB postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

# COPY init.sql /docker-entrypoint-initdb.d/init.sql 
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Expose the PostgreSQL default port
EXPOSE 5432

# docker build -t kevinity310/postgres-hms:11.5 .
# docker push kevinity310/postgres-hms:11.5 
# docker run --rm -it kevinity310/postgres-hms:11.5 /bin/bash


