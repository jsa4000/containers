FROM node:18 AS build

WORKDIR /opt/node_app

# Get the excalidraw source by specifing the version (tag)
ENV EXCALIDRAW_VERSION=v0.17.3
RUN git clone -b "${EXCALIDRAW_VERSION}" --single-branch --depth 1 https://github.com/excalidraw/excalidraw.git .

# do not ignore optional dependencies:
# Error: Cannot find module @rollup/rollup-linux-x64-gnu
RUN yarn --network-timeout 600000

ARG NODE_ENV=production

RUN yarn build:app:docker

FROM nginx:1.27-alpine

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
