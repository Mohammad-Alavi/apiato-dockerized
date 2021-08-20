FROM php:7.4-fpm

ARG install_node=0

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get -y update \
    && apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi

WORKDIR /var/www/html

COPY apiato .