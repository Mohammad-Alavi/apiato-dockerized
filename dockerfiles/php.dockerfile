FROM php:8.1.0-fpm-alpine AS php_base
LABEL maintainer="Mohammad Alavi"

# Install dependencies
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions mysqli pdo_mysql pgsql pdo_pgsql gd bcmath gmp mcrypt exif imagick gettext zip intl opcache && \
    apk add --update linux-headers && apk add --update nodejs && apk add rsync
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# add the opcache configuration file
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"


FROM masmikh/php_base:latest AS php_debug
RUN install-php-extensions xdebug
ENV XDEBUG_MODE=debug
ENV XDEBUG_CONFIG="client_host=host.docker.internal client_port=9003"

# Examples of conditional commands, kept for later
#ARG install_node=0
#ARG install_xdebug=0
# none alpine
#RUN if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; install-php-extensions xdebug ; fi
# alpine
#RUN if [ "$install_node" = 1 ]; then apk add --update nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; then install-php-extensions xdebug ; fi
