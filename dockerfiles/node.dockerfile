FROM node:latest

VOLUME /root/.npm

WORKDIR ${WORKING_DIR}

COPY ../config/.npmrc /root/.npmrc