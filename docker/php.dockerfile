ARG PHP_VER=8.1.0

FROM php:${PHP_VER}-fpm-alpine AS php

LABEL maintainer="Mohammad Alavi"
# Install dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# add the opcache configuration file
COPY /docker/config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
# install php extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN apk upgrade \
    && apk add --no-cache wget \
    && wget --no-check-certificate "https://pecl.php.net" \
    && install-php-extensions mysqli pdo_mysql pgsql pdo_pgsql intl opcache pcov bcmath \
    && apk add --update linux-headers && apk add --update nodejs

FROM masmikh/php-${PHP_VER}:latest AS php-debug
RUN install-php-extensions xdebug
ENV XDEBUG_MODE=debug
ENV XDEBUG_CONFIG="client_host=host.docker.internal client_port=9003"

# If you want to use this image as a production image, you can copy the project files to the container
# Install the dependencies (should this be done in nginx or php image? or both? or neither?)
#COPY package.json package-lock.json composer.json composer.lock ./
#RUN npm install && composer install
# We don't need composer in those php images. Do we? Can workflows like Github actions take care of that? I think they already do.
#WORKDIR ${WORKING_DIR}
#COPY ${PROJECT_FOLDER_NAME} .

# Examples of conditional commands, kept for later
#ARG install_node=0
#ARG install_xdebug=0
# none alpine
#RUN if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; install-php-extensions xdebug ; fi
# alpine
#RUN if [ "$install_node" = 1 ]; then apk add --update nodejs ; fi
#RUN if [ "$install_xdebug" = 1 ]; then install-php-extensions xdebug ; fi
