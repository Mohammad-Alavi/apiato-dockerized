FROM php:8.0.10-fpm-alpine

ARG install_node=0

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions mysqli pdo_mysql gd xdebug bcmath gmp intl mcrypt

# none alpine
RUN #if [ "$install_node" = 1 ]; then apt-get -y install nodejs ; fi
# alpine
RUN if [ "$install_node" = 1 ]; then apk add --update nodejs ; fi

ENV xdebug.mode=coverage

WORKDIR /var/www/html

COPY apiato .