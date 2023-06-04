FROM php:8.1.0-fpm-alpine AS php_base

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --update linux-headers
RUN install-php-extensions mysqli pdo_mysql pgsql pdo_pgsql gd bcmath gmp mcrypt exif imagick gettext zip
RUN install-php-extensions opcache

RUN echo memory_limit = -1 >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

ENV xdebug.mode=coverage

# add the opcache configuration file
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"

WORKDIR /var/www/html

COPY ${PROJECT_FOLDER_NAME} .

FROM php_base AS php_debug
RUN install-php-extensions xdebug

FROM php_base AS php_test

FROM php_base AS php_composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions intl

FROM php_base AS php_artisan
RUN apk add --update nodejs

# Examples of conditional commands, kept for later
#ARG install_node=0
#ARG install_xdebug=0
# none alpine
#RUN if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; install-php-extensions xdebug ; fi
# alpine
#RUN if [ "$install_node" = 1 ]; then apk add --update nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; then install-php-extensions xdebug ; fi
