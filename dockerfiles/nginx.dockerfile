FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

COPY ../configs/nginx.conf .

RUN mv nginx.conf default.conf

WORKDIR /var/www/html

COPY ${PROJECT_FOLDER_NAME} .