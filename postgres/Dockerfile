FROM postgres:11.5

# COPY init.sql /docker-entrypoint-initdb.d/init.sql 
COPY --chown=postgres:postgres init.sql /docker-entrypoint-initdb.d/

# docker build -t kevinity310/postgres-hms:11.5 .
# docker run --rm -it kevinity310/postgres-hms:11.5 /bin/bash


# docker push kevinity310/ubuntu22.04:v1 
