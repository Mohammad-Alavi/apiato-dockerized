FROM composer:latest

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions intl

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]