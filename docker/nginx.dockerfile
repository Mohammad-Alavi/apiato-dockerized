FROM nginx:stable-alpine

#WORKDIR /etc/nginx/conf.d

#COPY /docker/config/nginx.conf .
#https://stackoverflow.com/questions/72748706/how-to-pass-environment-variable-to-nginx-conf-file-in-docker
COPY /docker/config/nginx.conf /etc/nginx/templates/nginx.conf.template

EXPOSE 80

#RUN mv nginx.conf default.conf

# If you want to use this image as a production image, you can copy the project files to the container
#WORKDIR ${WORKING_DIR}
#COPY ${PROJECT_FOLDER_NAME} .