FROM node:18

VOLUME /root/.npm

WORKDIR /opt/project

COPY ../config/.npmrc /root/.npmrc