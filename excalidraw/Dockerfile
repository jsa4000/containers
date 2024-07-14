FROM node:18 AS build

WORKDIR /opt/node_app

#ARG NODE_ENV=production
ENV EXCALIDRAW_VERSION=v0.17.3

RUN git clone -b "${EXCALIDRAW_VERSION}" --single-branch --depth 1 https://github.com/excalidraw/excalidraw.git . \
   && yarn --ignore-optional --network-timeout 600000 \
   && yarn build:app:docker

FROM nginx:1.21-alpine

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
