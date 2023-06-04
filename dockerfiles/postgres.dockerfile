FROM ghcr.io/baosystems/postgis:14-3.3

# Copy in the load-extensions script
#COPY ./postgres/load-extensions.sh /docker-entrypoint-initdb.d/
COPY ./postgres/install-citext.sql /docker-entrypoint-initdb.d/

