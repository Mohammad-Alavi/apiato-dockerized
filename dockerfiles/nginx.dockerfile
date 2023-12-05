FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

COPY ../config/nginx.conf .

RUN mv nginx.conf default.conf

WORKDIR /opt/project

COPY ${PROJECT_FOLDER_NAME} .