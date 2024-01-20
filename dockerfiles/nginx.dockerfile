FROM nginx:stable-alpine

#WORKDIR /etc/nginx/conf.d

#COPY ../config/nginx.conf .
#https://stackoverflow.com/questions/72748706/how-to-pass-environment-variable-to-nginx-conf-file-in-docker
COPY ../config/nginx.conf /etc/nginx/templates/nginx.conf.template

EXPOSE 80

RUN #mv nginx.conf default.conf

WORKDIR /opt/project

COPY ${PROJECT_FOLDER_NAME} .