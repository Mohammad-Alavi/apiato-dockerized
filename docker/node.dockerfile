FROM node:21.6.2-slim

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

VOLUME /root/.npm

COPY config/.npmrc /root/.npmrc