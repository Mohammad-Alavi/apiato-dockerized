FROM php:8.1.0-fpm-alpine

ARG install_node=0

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions mysqli pdo_mysql pgsql pdo_pgsql gd bcmath gmp intl mcrypt exif imagick

# none alpine
RUN #if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi
# alpine
RUN if [ "$install_node" = 1 ]; then apk add --update nodejs ; fi

WORKDIR /var/www/html
COPY ${PROJECT_FOLDER_NAME} .